<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\BrokerProfile;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Redis;
use Illuminate\Support\Str;

class OAuthController extends Controller
{
    private function calculateProfileCompletion(User $user): string
    {
        $user->loadMissing('agency');
        $required = [
            !empty($user->phone),
            !empty($user->email),
        ];

        if (($user->account_type ?? 'personal') === 'agency') {
            $required[] = !empty(optional($user->agency)->name);
            $required[] = !empty(optional($user->agency)->address);
        }

        $total = count($required);
        $filled = count(array_filter($required));
        $percent = $total > 0 ? (int) round(($filled / $total) * 100) : 0;

        return $percent . '%';
    }

    private function profilePayload(User $user): array
    {
        $user->loadMissing('agency');
        $agency = $user->agency;

        return [
            'profile_picture' => $user->profile_photo,
            'first_name' => $user->first_name,
            'last_name' => $user->last_name,
            'phone' => $user->phone,
            'email' => $user->email,
            'status' => $user->status,
            'profile_completion' => $this->calculateProfileCompletion($user),
            'account_type' => $user->account_type ?? 'personal',
            'agency' => $agency ? [
                'agency_name' => $agency->name,
                'agency_logo' => $agency->logo,
                'agency_address' => $agency->address,
                'attachments' => $agency->attachments ?? [],
            ] : null,
        ];
    }

    /**
     * POST /api/auth/oauth/challenge
     * Frontend should call this before starting OAuth to get `state` (and `nonce` for providers that use it).
     *
     * Payload:
     * - provider: google|facebook|apple
     *
     * Response:
     * - state
     * - nonce (optional for apple/google)
     */
    public function challenge(Request $request)
    {
        $data = $request->validate([
            'provider' => 'required|string|in:google,facebook,apple',
        ]);

        $provider = $data['provider'];
        $ttlSeconds = 300;

        $state = (string) Str::random(32);
        Redis::setex("oauth:state:{$provider}:{$state}", $ttlSeconds, '1');

        $response = [
            'state' => $state,
        ];

        if (in_array($provider, ['google', 'apple'], true)) {
            $nonce = (string) Str::random(32);
            Redis::setex("oauth:nonce:{$provider}:{$nonce}", $ttlSeconds, '1');
            $response['nonce'] = $nonce;
        }

        return response()->json($response);
    }

    /**
     * POST /api/auth/google
     * Payload:
     * - id_token (Google ID token JWT)
     * - state (optional)
     */
    public function google(Request $request)
    {
        try {
            $data = $request->validate([
                'id_token' => 'required|string',
                'state' => 'nullable|string|max:255',
                'nonce' => 'nullable|string|max:255',
            ]);

            $this->validateOptionalCsrfState('google', $data['state'] ?? null);

            $verified = $this->verifyGoogleIdToken($data['id_token']);

            $providerId = (string) ($verified['sub'] ?? $verified['user_id'] ?? '');
            $email = $verified['email'] ?? null;
            if (!$providerId || !$email) {
                return response()->json([
                    'message' => 'Invalid Google token.',
                ], 422);
            }

            $firstName = $verified['given_name'] ?? null;
            $lastName = $verified['family_name'] ?? null;
            $name = $verified['name'] ?? null;
            if (empty($firstName)) {
                [$firstName, $lastName] = $this->splitName($name, $firstName);
            }

            return $this->loginOrCreateOAuthUser('google', $providerId, $email, $firstName, $lastName);
        } catch (\Throwable $e) {
            return response()->json([
                'message' => $e->getMessage() ?: 'Google OAuth failed.',
            ], $e->getCode() >= 400 && $e->getCode() < 600 ? $e->getCode() : 422);
        }
    }

    /**
     * POST /api/auth/facebook
     * Payload:
     * - access_token
     * - state (optional)
     */
    public function facebook(Request $request)
    {
        try {
            $data = $request->validate([
                'access_token' => 'required|string',
                'state' => 'nullable|string|max:255',
            ]);

            $this->validateOptionalCsrfState('facebook', $data['state'] ?? null);

            $appId = env('FACEBOOK_APP_ID');
            $appSecret = env('FACEBOOK_APP_SECRET');
            if (!$appId || !$appSecret) {
                return response()->json([
                    'message' => 'Facebook OAuth not configured.',
                ], 500);
            }

            $debug = $this->verifyFacebookAccessToken($appId, $appSecret, $data['access_token']);
            $providerId = (string) ($debug['user_id'] ?? '');

            // Fetch profile info for email/name
            $me = $this->fetchFacebookMe($data['access_token']);
            $email = $me['email'] ?? null;
            if (!$providerId || !$email) {
                return response()->json([
                    'message' => 'Invalid Facebook token or missing email.',
                ], 422);
            }

            [$firstName, $lastName] = $this->splitName($me['name'] ?? null, null);

            return $this->loginOrCreateOAuthUser('facebook', $providerId, $email, $firstName, $lastName);
        } catch (\Throwable $e) {
            return response()->json([
                'message' => $e->getMessage() ?: 'Facebook OAuth failed.',
            ], 422);
        }
    }

    /**
     * POST /api/auth/apple
     * Payload:
     * - id_token (Apple JWT)
     * - nonce (optional)
     * - state (optional)
     */
    public function apple(Request $request)
    {
        try {
            $data = $request->validate([
                'id_token' => 'required|string',
                'nonce' => 'nullable|string|max:255',
                'state' => 'nullable|string|max:255',
            ]);

            $this->validateOptionalCsrfState('apple', $data['state'] ?? null);

            $verified = $this->verifyAppleIdToken($data['id_token'], env('APPLE_CLIENT_ID'), $data['nonce'] ?? null);

            $providerId = (string) ($verified['sub'] ?? '');
            $email = $verified['email'] ?? null;
            if (!$providerId) {
                return response()->json([
                    'message' => 'Invalid Apple token.',
                ], 422);
            }

            $name = $verified['name'] ?? null;
            $givenName = $verified['given_name'] ?? null;
            $familyName = $verified['family_name'] ?? null;

            if (empty($givenName)) {
                [$givenName, $familyName] = $this->splitName($name, null);
            }

            // Apple might not send email on every login; link by provider id first.
            return $this->loginOrCreateOAuthUser(
                'apple',
                $providerId,
                $email,
                $givenName,
                $familyName
            );
        } catch (\Throwable $e) {
            return response()->json([
                'message' => $e->getMessage() ?: 'Apple OAuth failed.',
            ], 422);
        }
    }

    private function loginOrCreateOAuthUser(string $provider, string $providerId, ?string $email, ?string $firstName, ?string $lastName)
    {
        $providerIdColumn = match ($provider) {
            'google' => 'google_id',
            'facebook' => 'facebook_id',
            'apple' => 'apple_id',
            default => null,
        };

        if (!$providerIdColumn) {
            return response()->json(['message' => 'Unsupported provider.'], 422);
        }

        $user = User::where($providerIdColumn, $providerId)->first();

        // If user exists -> login + update missing fields.
        if ($user) {
            if ($email && !$user->email) {
                $user->email = $email;
                $user->email_verified_at = Carbon::now();
            }
            $this->updateUserNameFields($user, $firstName, $lastName);

            $user->save();
            $this->ensureBrokerProfile($user);

            $token = $user->createToken('mobile')->plainTextToken;

            return response()->json([
                'token' => $token,
                'user' => $user,
                'profile' => $this->profilePayload($user),
                'profile_completion' => $this->calculateProfileCompletion($user),
            ]);
        }

        // If not exists: we require email to create a new user.
        if (!$email) {
            return response()->json([
                'message' => 'Email is required for first-time OAuth signup.',
            ], 422);
        }

        // Try match by email to avoid duplicate accounts.
        $userByEmail = User::where('email', $email)->first();
        if ($userByEmail) {
            $userByEmail->{$providerIdColumn} = $providerId;
            $this->updateUserNameFields($userByEmail, $firstName, $lastName);
            $userByEmail->email_verified_at = Carbon::now();
            $userByEmail->save();

            $this->ensureBrokerProfile($userByEmail);

            $token = $userByEmail->createToken('mobile')->plainTextToken;

            return response()->json([
                'token' => $token,
                'user' => $userByEmail,
                'profile' => $this->profilePayload($userByEmail),
                'profile_completion' => $this->calculateProfileCompletion($userByEmail),
            ]);
        }

        // Create new user (same table used by signup/login).
        $firstName = $firstName ?: Str::before(Str::ucfirst(Str::slug((string) $email, '')), '@') ?: 'Broker';
        $lastName = $lastName ?: null;
        $derivedName = trim((string) $firstName . ' ' . (string) ($lastName ?? ''));

        $user = User::create([
            'name' => $derivedName,
            'first_name' => (string) $firstName,
            'last_name' => $lastName,
            'email' => $email,
            'phone' => null,
            'language' => 'en',
            'role' => 'broker',
            'status' => 'active',
            // OAuth user ke liye password required field ko satisfy karne ke liye random hash.
            'password' => Hash::make(Str::random(32)),
            $providerIdColumn => $providerId,
            'email_verified_at' => Carbon::now(),
        ]);

        $this->ensureBrokerProfile($user);

        $token = $user->createToken('mobile')->plainTextToken;

        return response()->json([
            'token' => $token,
            'user' => $user,
            'profile' => $this->profilePayload($user),
            'profile_completion' => $this->calculateProfileCompletion($user),
        ]);
    }

    private function ensureBrokerProfile(User $user): void
    {
        if (!$user->brokerProfile) {
            BrokerProfile::create([
                'user_id' => $user->id,
                'company_name' => 'Freelance Agent',
                'verified' => true,
                'is_active' => true,
                'show_whatsapp' => true,
                'experience_years' => 0,
                'bio' => null,
                'brn_number' => null,
            ]);
        }
    }

    private function updateUserNameFields(User $user, ?string $firstName, ?string $lastName): void
    {
        if ($firstName !== null) {
            $user->first_name = $firstName;
        }
        if ($lastName !== null) {
            $user->last_name = $lastName;
        }

        $full = trim((string) ($user->first_name ?? '') . ' ' . (string) ($user->last_name ?? ''));
        if ($full !== '') {
            $user->name = $full;
        }
    }

    private function splitName(?string $name, ?string $firstOverride): array
    {
        $name = trim((string) ($name ?? ''));
        if ($firstOverride) {
            $first = trim((string) $firstOverride);
        } else {
            $first = $name ? Str::before($name, ' ') : null;
        }

        $last = null;
        if ($name) {
            $parts = preg_split('/\s+/', $name, -1, PREG_SPLIT_NO_EMPTY);
            if (count($parts) > 1) {
                $last = implode(' ', array_slice($parts, 1));
            }
        }

        return [$first ?: null, $last];
    }

    private function validateOptionalCsrfState(string $provider, ?string $state): void
    {
        if (empty($state)) {
            return;
        }

        $enforce = filter_var(env('OAUTH_STATE_ENFORCE', 'true'), FILTER_VALIDATE_BOOLEAN);

        $key = "oauth:state:{$provider}:{$state}";
        $expected = Redis::get($key);
        if (!$expected) {
            throw new \RuntimeException('Invalid state.', 422);
        }

        Redis::del($key);
    }

    private function verifyGoogleIdToken(string $idToken): array
    {
        $clientId = env('GOOGLE_CLIENT_ID');
        if (!$clientId) {
            throw new \RuntimeException('Google OAuth not configured.');
        }

        // Google tokeninfo endpoint does signature verification on Google side.
        $res = Http::get('https://oauth2.googleapis.com/tokeninfo', [
            'id_token' => $idToken,
        ]);

        if (!$res->ok()) {
            throw new \RuntimeException('Invalid Google token.');
        }

        $payload = $res->json();

        $aud = $payload['audience'] ?? $payload['aud'] ?? null;
        if ($aud !== $clientId) {
            throw new \RuntimeException('Google audience mismatch.');
        }

        return [
            'sub' => $payload['sub'] ?? ($payload['user_id'] ?? null),
            'email' => $payload['email'] ?? null,
            'email_verified' => (bool) ($payload['email_verified'] ?? false),
            'given_name' => $payload['given_name'] ?? null,
            'family_name' => $payload['family_name'] ?? null,
            'name' => $payload['name'] ?? null,
        ];
    }

    private function verifyFacebookAccessToken(string $appId, string $appSecret, string $accessToken): array
    {
        $appAccessToken = $appId . '|' . $appSecret;

        $debugRes = Http::get('https://graph.facebook.com/debug_token', [
            'input_token' => $accessToken,
            'access_token' => $appAccessToken,
        ]);

        if (!$debugRes->ok()) {
            throw new \RuntimeException('Invalid Facebook token.');
        }

        $payload = $debugRes->json();
        $data = $payload['data'] ?? [];

        if (empty($data['is_valid'])) {
            throw new \RuntimeException('Facebook token is not valid.');
        }

        if (!empty($data['app_id']) && (string) $data['app_id'] !== (string) $appId) {
            throw new \RuntimeException('Facebook app mismatch.');
        }

        return [
            'user_id' => $data['user_id'] ?? null,
        ];
    }

    private function fetchFacebookMe(string $accessToken): array
    {
        $meRes = Http::get('https://graph.facebook.com/me', [
            'fields' => 'id,name,email',
            'access_token' => $accessToken,
        ]);

        if (!$meRes->ok()) {
            throw new \RuntimeException('Failed to fetch Facebook profile.');
        }

        return $meRes->json();
    }

    private function verifyAppleIdToken(string $idToken, ?string $clientId, ?string $nonce): array
    {
        if (!$clientId) {
            throw new \RuntimeException('Apple OAuth not configured.');
        }

        $parts = explode('.', $idToken);
        if (count($parts) !== 3) {
            throw new \RuntimeException('Invalid Apple token format.');
        }

        [$headerB64, $payloadB64, $signatureB64] = $parts;

        $header = json_decode($this->base64UrlDecode($headerB64), true);
        $payload = json_decode($this->base64UrlDecode($payloadB64), true);
        $signature = $this->base64UrlDecode($signatureB64);

        if (!is_array($header) || !is_array($payload)) {
            throw new \RuntimeException('Invalid Apple token payload.');
        }

        $kid = $header['kid'] ?? null;
        $alg = $header['alg'] ?? null;
        if (!$kid || $alg !== 'RS256') {
            throw new \RuntimeException('Unsupported Apple token.');
        }

        $jwks = Http::get('https://appleid.apple.com/auth/keys')->json();
        $keys = $jwks['keys'] ?? [];
        $jwk = null;
        foreach ($keys as $k) {
            if (($k['kid'] ?? null) === $kid) {
                $jwk = $k;
                break;
            }
        }
        if (!$jwk) {
            throw new \RuntimeException('Apple JWK not found.');
        }

        $pem = $this->appleJwkToPem($jwk);
        $dataToVerify = $headerB64 . '.' . $payloadB64;

        $verified = openssl_verify($dataToVerify, $signature, $pem, OPENSSL_ALGO_SHA256);
        if ($verified !== 1) {
            throw new \RuntimeException('Apple signature verification failed.');
        }

        // Claims validation
        $iss = $payload['iss'] ?? null;
        $aud = $payload['aud'] ?? null;
        $exp = $payload['exp'] ?? null;

        if (!$iss || (string) $iss !== 'https://appleid.apple.com') {
            throw new \RuntimeException('Apple issuer mismatch.');
        }

        if (is_array($aud)) {
            $audOk = in_array($clientId, $aud, true);
        } else {
            $audOk = ((string) $aud === (string) $clientId);
        }
        if (!$audOk) {
            throw new \RuntimeException('Apple audience mismatch.');
        }

        if ($exp && (int) $exp < now()->timestamp) {
            throw new \RuntimeException('Apple token expired.');
        }

        $tokenNonce = $payload['nonce'] ?? null;
        if ($tokenNonce !== null) {
            if ($nonce === null || (string) $tokenNonce !== (string) $nonce) {
                throw new \RuntimeException('Apple nonce mismatch.', 422);
            }

            // Ensure nonce came from our challenge endpoint.
            $nonceKey = "oauth:nonce:apple:{$nonce}";
            if (!Redis::get($nonceKey)) {
                throw new \RuntimeException('Invalid nonce.', 422);
            }
            Redis::del($nonceKey);
        }

        return $payload;
    }

    private function base64UrlDecode(string $data): string
    {
        $data = strtr($data, '-_', '+/');
        $pad = strlen($data) % 4;
        if ($pad) {
            $data .= str_repeat('=', 4 - $pad);
        }

        return base64_decode($data);
    }

    private function appleJwkToPem(array $jwk): string
    {
        $modulus = $this->base64UrlDecode((string) ($jwk['n'] ?? ''));
        $exponent = $this->base64UrlDecode((string) ($jwk['e'] ?? ''));
        if (!$modulus || !$exponent) {
            throw new \RuntimeException('Invalid Apple JWK.');
        }

        $modInt = $this->asn1EncodeInteger($modulus);
        $expInt = $this->asn1EncodeInteger($exponent);
        $rsaSeq = $this->asn1EncodeSequence($modInt . $expInt);

        // AlgorithmIdentifier for rsaEncryption: 1.2.840.113549.1.1.1 with NULL parameters.
        $algoId = "\x30" . "\x0d" .
            "\x06\x09\x2a\x86\x48\x86\xf7\x0d\x01\x01\x01" .
            "\x05\x00";

        $bitString = "\x03" . $this->asn1EncodeLength(strlen($rsaSeq) + 1) . "\x00" . $rsaSeq;

        $der = "\x30" . $this->asn1EncodeLength(strlen($algoId) + strlen($bitString)) . $algoId . $bitString;

        return "-----BEGIN PUBLIC KEY-----\n" .
            chunk_split(base64_encode($der), 64, "\n") .
            "-----END PUBLIC KEY-----";
    }

    private function asn1EncodeInteger(string $bytes): string
    {
        $bytes = ltrim($bytes, "\x00");
        if ($bytes === '') {
            $bytes = "\x00";
        }

        // Ensure positive INTEGER
        if ((ord($bytes[0]) & 0x80) !== 0) {
            $bytes = "\x00" . $bytes;
        }

        return "\x02" . $this->asn1EncodeLength(strlen($bytes)) . $bytes;
    }

    private function asn1EncodeSequence(string $content): string
    {
        return "\x30" . $this->asn1EncodeLength(strlen($content)) . $content;
    }

    private function asn1EncodeLength(int $length): string
    {
        if ($length < 128) {
            return chr($length);
        }

        $temp = ltrim(pack('N', $length), "\x00");
        $lenBytes = strlen($temp);

        return chr(0x80 | $lenBytes) . $temp;
    }
}

