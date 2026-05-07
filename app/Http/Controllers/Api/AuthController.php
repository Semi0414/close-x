<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\BrokerProfile;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class AuthController extends Controller
{
    private function normalizeAuthIdentifiers(Request $request): array
    {
        $phone = $request->input('phone', $request->input('mobile', $request->input('mobileNumber', $request->input('phone_number'))));
        $email = $request->input('email', $request->input('business_email', $request->input('businessEmail')));

        $request->merge([
            'phone' => $phone,
            'email' => $email,
        ]);

        return [$phone, $email];
    }

    private function profileCompletionNote(array $missingFields): string
    {
        if (empty($missingFields)) {
            return 'Profile completion is 100%. All required fields are filled.';
        }

        return 'Profile completion is not 100% because these required fields are missing: ' . implode(', ', $missingFields) . '.';
    }

    private function profileCompletionDetails(User $user): array
    {
        $user->loadMissing(['agency', 'brokerProfile']);
        $agency = $user->agency;
        $brokerProfile = $user->brokerProfile;
        $accountType = $user->account_type ?? 'personal';

        if ($accountType === 'agency') {
            $requiredFields = [
                'first_name' => !empty($user->first_name),
                'last_name' => !empty($user->last_name),
                'phone' => !empty($user->phone),
                'brn_no' => !empty($brokerProfile?->brn_number),
                'agency_name' => !empty($agency?->name),
                'agency_address' => !empty($agency?->address),
                'agency_orn_no' => !empty($agency?->orn),
                'agency_ded_license_no' => !empty($agency?->ded_license),
                'agency_city' => !empty($agency?->city),
                'agency_phone_no' => !empty($agency?->phone),
                'agency_whatsapp_no' => !empty($agency?->whatsapp),
                'agency_email' => !empty($agency?->email),
            ];
        } else {
            $requiredFields = [
                'phone' => !empty($user->phone),
                'email' => !empty($user->email),
                'brn_no' => !empty($brokerProfile?->brn_number),
            ];
        }

        $total = count($requiredFields);
        $filled = count(array_filter($requiredFields));
        $percent = $total > 0 ? (int) round(($filled / $total) * 100) : 0;

        return [
            'percent' => $percent,
            'missing_required_fields' => array_keys(array_filter($requiredFields, function ($isFilled) {
                return $isFilled === false;
            })),
            'required_fields' => array_keys($requiredFields),
        ];
    }

    private function ensureProfileDefaults(User $user): void
    {
        $dirty = false;

        if ($user->phone_notifications === null) {
            $user->phone_notifications = true;
            $dirty = true;
        }
        if ($user->messages_notifications === null) {
            $user->messages_notifications = true;
            $dirty = true;
        }
        if ($user->whatsapp_notifications === null) {
            $user->whatsapp_notifications = true;
            $dirty = true;
        }
        if (empty($user->account_type)) {
            $user->account_type = 'personal';
            $dirty = true;
        }
        if ($user->status === 'pending' || empty($user->status)) {
            $user->status = 'active';
            $dirty = true;
        }

        if ($dirty) {
            $user->save();
        }
    }

    private function calculateProfileCompletionPercent(User $user): int
    {
        return $this->profileCompletionDetails($user)['percent'];
    }

    private function updateProfileCompletionPercent(User $user): int
    {
        $percent = $this->calculateProfileCompletionPercent($user);
        $user->profile_completion_percent = $percent;
        $user->save();

        return $percent;
    }

    private function calculateProfileCompletion(User $user): string
    {
        $percent = $this->calculateProfileCompletionPercent($user);
        return $percent . '%';
    }

    private function profilePayload(User $user): array
    {
        $user->load(['agency', 'brokerProfile']);
        $agency = $user->agency;
        $brokerProfile = $user->brokerProfile;
        $completionDetails = $this->profileCompletionDetails($user);

        return [
            'profile_picture' => $user->profile_photo,
            'first_name' => $user->first_name,
            'last_name' => $user->last_name,
            'phone' => $user->phone,
            'email' => $user->email,
            'status' => $user->status,
            'profile_completion' => ($user->profile_completion_percent ?? $completionDetails['percent']) . '%',
            'profile_completion_percent' => $user->profile_completion_percent ?? $completionDetails['percent'],
            'missing_required_fields' => $completionDetails['missing_required_fields'],
            'required_fields_for_completion' => $completionDetails['required_fields'],
            'profile_completion_note' => $this->profileCompletionNote($completionDetails['missing_required_fields']),
            'phone_notifications' => (bool) $user->phone_notifications,
            'messages_notifications' => (bool) $user->messages_notifications,
            'whatsapp_notifications' => (bool) $user->whatsapp_notifications,
            'account_type' => $user->account_type ?? 'personal',
            'brn_no' => $brokerProfile?->brn_number,
            'short_bio' => $brokerProfile?->bio,
            'agency' => $agency ? [
                'agency_name' => $agency->name,
                'agency_logo' => $agency->logo,
                'agency_address' => $agency->address,
                'agency_orn_no' => $agency->orn,
                'agency_ded_license_no' => $agency->ded_license,
                'agency_city' => $agency->city,
                'agency_phone_no' => $agency->phone,
                'agency_whatsapp_no' => $agency->whatsapp,
                'attachments' => $agency->attachments ?? [],
            ] : null,
        ];
    }

    /**
     * Create account (password-based) + issue Sanctum token.
     *
     * Expected payload (from UI):
     * - full_name (or name / first_name)
     * - last_name
     * - phone (or mobile)
     * - email (or business_email)
     * - password
     * - confirm_password (or password_confirmation)
     */
    public function signup(Request $request)
    {
        $fullName = $request->input('full_name', $request->input('fullName'));
        $name = $request->input('name', $fullName);
        $firstName = $request->input('first_name', $request->input('firstName', $name));
        $lastName = $request->input('last_name', $request->input('lastName'));
        $phone = $request->input('phone', $request->input('mobile', $request->input('mobileNumber', $request->input('phone_number'))));
        $email = $request->input('email', $request->input('business_email', $request->input('businessEmail')));
        $password = $request->input('password');
        $confirmPassword = $request->input('confirm_password', $request->input('confirmPassword', $request->input('password_confirmation')));

        $request->merge([
            'full_name' => $fullName ?? $name ?? $firstName,
            'name' => $name ?? $firstName,
            'first_name' => $firstName,
            'last_name' => $lastName,
            'phone' => $phone,
            'email' => $email,
            'confirm_password' => $confirmPassword,
        ]);

        $data = $request->validate([
            'full_name' => 'required|string|max:255',
            'name' => 'nullable|string|max:255',
            'first_name' => 'nullable|string|max:255',
            'last_name' => 'nullable|string|max:255',
            'phone' => 'required|string|max:20',
            'email' => 'required|email|max:255',
            'password' => 'required|string|min:8',
            'confirm_password' => 'required|string|same:password',
            'language' => 'nullable|string|max:10',
            'brn_no' => 'nullable|string|max:100',
            'short_bio' => 'nullable|string',
        ]);

        $derivedName = trim((string) ($data['full_name'] ?? $data['name'] ?? ''));
        if ($derivedName === '') {
            $derivedName = trim((string) ($data['first_name'] ?? '') . ' ' . (string) ($data['last_name'] ?? ''));
        }

        $emailExists = User::where('email', $data['email'])->exists();
        if ($emailExists) {
            return response()->json([
                'message' => 'This email is already registered.',
            ], 422);
        }

        $phoneExists = User::where('phone', $data['phone'])->exists();
        if ($phoneExists) {
            return response()->json([
                'message' => 'This phone number is already registered.',
            ], 422);
        }

        $channel = !empty($data['phone']) ? 'phone' : 'email';
        $identifier = $channel === 'phone' ? $data['phone'] : $data['email'];

        $otp = random_int(100000, 999999);
        $otpKey = "otp:signup:{$channel}:{$identifier}";
        $pendingKey = "signup:pending:{$channel}:{$identifier}";

        Cache::put($otpKey, (string) $otp, now()->addMinutes(5));
        Cache::put($pendingKey, json_encode([
            'name' => $derivedName,
            'first_name' => $data['first_name'] ?? $data['full_name'] ?? $data['name'],
            'last_name' => $data['last_name'] ?? null,
            'email' => $data['email'],
            'phone' => $data['phone'],
            'language' => $request->input('language', 'en'),
            'password' => Hash::make($data['password']),
            'short_bio' => $data['short_bio'] ?? null,
            'brn_no' => $data['brn_no'] ?? null,
        ]), now()->addMinutes(5));

        return response()->json([
            'message' => 'OTP sent successfully. Please verify to complete signup.',
            'otp_required' => true,
        ]);
    }

    /**
     * Request OTP for login/signup.
     */
    public function login(Request $request)
    {
        [$phone, $email] = $this->normalizeAuthIdentifiers($request);

        $request->validate([
            'phone' => 'nullable|string|max:20',
            'email' => 'nullable|email|max:255',
            'password' => 'required|string',
        ]);

        if (!$phone && !$email) {
            return response()->json([
                'message' => 'Phone or email is required.',
            ], 422);
        }

        $user = $phone
            ? User::where('phone', $phone)->first()
            : User::where('email', $email)->first();

        if (!$user || !Hash::check((string) $request->input('password'), (string) $user->password)) {
            return response()->json([
                'message' => 'Invalid credentials.',
            ], 422);
        }

        $this->ensureProfileDefaults($user);
        $token = $user->createToken('auth_token')->plainTextToken;
        $completionPercent = $this->updateProfileCompletionPercent($user);
        $completionDetails = $this->profileCompletionDetails($user);

        return response()->json([
            'token' => $token,
            'user' => $user,
            'profile' => $this->profilePayload($user),
            'profile_completion' => $completionPercent . '%',
            'missing_required_fields' => $completionDetails['missing_required_fields'],
            'profile_completion_note' => $this->profileCompletionNote($completionDetails['missing_required_fields']),
        ]);
    }

    /**
     * Verify OTP and issue token.
     */
    public function verifyOtp(Request $request)
    {
        [$phone, $email] = $this->normalizeAuthIdentifiers($request);

        $data = $request->validate([
            'phone' => 'required_without:email|string|max:20',
            'email' => 'nullable|email|max:255',
            'otp' => 'required|string',
        ]);

        $identifier = $phone ?? $email;
        $channel = $phone ? 'phone' : 'email';

        $otpKey = "otp:signup:{$channel}:{$identifier}";
        $pendingKey = "signup:pending:{$channel}:{$identifier}";
        $storedOtp = Cache::get($otpKey);
        $pendingRaw = Cache::get($pendingKey);

        if (!$storedOtp || !$pendingRaw || (string) $storedOtp !== (string) $data['otp']) {
            return response()->json([
                'message' => 'Invalid or expired OTP.',
            ], 422);
        }

        $pending = json_decode($pendingRaw, true);
        if (!is_array($pending)) {
            return response()->json([
                'message' => 'Signup session expired. Please signup again.',
            ], 422);
        }

        if (!empty($pending['email']) && User::where('email', $pending['email'])->exists()) {
            return response()->json([
                'message' => 'This email is already registered.',
            ], 422);
        }
        if (!empty($pending['phone']) && User::where('phone', $pending['phone'])->exists()) {
            return response()->json([
                'message' => 'This phone number is already registered.',
            ], 422);
        }

        $user = User::create([
            'name' => $pending['name'] ?? ('Broker ' . Str::random(6)),
            'first_name' => $pending['first_name'] ?? null,
            'last_name' => $pending['last_name'] ?? null,
            'email' => $pending['email'] ?? null,
            'phone' => $pending['phone'] ?? null,
            'language' => $pending['language'] ?? 'en',
            'role' => 'broker',
            'status' => 'active',
            'phone_notifications' => true,
            'messages_notifications' => true,
            'whatsapp_notifications' => true,
            'account_type' => 'personal',
            'password' => $pending['password'] ?? bcrypt(Str::random(32)),
        ]);

        BrokerProfile::create([
            'user_id' => $user->id,
            'company_name' => '',
            'verified' => true,
            'is_active' => true,
            'show_whatsapp' => true,
            'experience_years' => 0,
            'bio' => $pending['short_bio'] ?? null,
            'brn_number' => $pending['brn_no'] ?? null,
        ]);

        Cache::forget($otpKey);
        Cache::forget($pendingKey);

        $this->ensureProfileDefaults($user);
        $token = $user->createToken('mobile')->plainTextToken;
        $completionPercent = $this->updateProfileCompletionPercent($user);
        $completionDetails = $this->profileCompletionDetails($user);

        return response()->json([
            'token' => $token,
            'user' => $user,
            'profile' => $this->profilePayload($user),
            'profile_completion' => $completionPercent . '%',
            'missing_required_fields' => $completionDetails['missing_required_fields'],
            'profile_completion_note' => $this->profileCompletionNote($completionDetails['missing_required_fields']),
        ]);
    }

    /**
     * Logout current user (revoke tokens).
     */
    public function logout(Request $request)
    {
        $user = $request->user();

        if ($user) {
            $user->currentAccessToken()?->delete();
        }

        return response()->json([
            'message' => 'Logged out successfully.',
        ]);
    }
}


