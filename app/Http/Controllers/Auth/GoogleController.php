<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Laravel\Socialite\Facades\Socialite;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use App\Models\User;
use Illuminate\Support\Facades\Auth;


class GoogleController extends Controller
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

    public function redirect()
    {
        return Socialite::driver('google')->stateless()->redirect();
    }

    public function googleLogin(Request $request)
    {
        $request->validate([
            'token' => 'required'
        ]);
    
        $response = Http::get('https://oauth2.googleapis.com/tokeninfo', [
            'id_token' => $request->token
        ]);
    
        if ($response->failed()) {
            return response()->json(['error' => 'Invalid Google token'], 401);
        }
    
        $googleUser = $response->json();

        $email = $googleUser['email'] ?? null;
        if (!$email) {
            return response()->json(['error' => 'Email not found in Google token'], 422);
        }

        $user = User::firstOrNew(['email' => $email]);

        $user->name = $googleUser['name'] ?? $user->name ?? 'Google User';
        $user->google_id = $googleUser['sub'] ?? $user->google_id;
        $user->profile_photo = $googleUser['picture'] ?? $user->profile_photo;
        if (!$user->exists) {
            $user->password = bcrypt('dummy123');
        }
        if ($user->status === 'pending' || empty($user->status)) {
            $user->status = 'active';
        }

        // id_token me phone har time nahi aata, isliye only-when-available update.
        if (!empty($googleUser['phone_number'])) {
            $user->phone = $googleUser['phone_number'];
        }

        $user->save();
    
        $token = $user->createToken('auth_token')->plainTextToken;
    
        return response()->json([
            'user' => $user,
            'token' => $token,
            'profile' => $this->profilePayload($user),
            'profile_completion' => $this->calculateProfileCompletion($user),
        ]);
    }
    public function callback()
    {
        try {
            $googleUser = Socialite::driver('google')->stateless()->user();

            $email = $googleUser->getEmail();
            if (!$email) {
                return response()->json([
                    'error' => 'Email not found from Google'
                ], 422);
            }

            $user = User::firstOrNew(['email' => $email]);

            $user->name = $googleUser->getName() ?? $user->name ?? 'Google User';
            $user->google_id = $googleUser->getId() ?? $user->google_id;
            $user->profile_photo = $googleUser->getAvatar() ?? $user->profile_photo;
            if (!$user->exists) {
                $user->password = bcrypt('123456dummy');
            }
            if ($user->status === 'pending' || empty($user->status)) {
                $user->status = 'active';
            }

            // Socialite default payload me phone number usually available nahi hota.
            if (!empty($googleUser->user['phone_number'])) {
                $user->phone = $googleUser->user['phone_number'];
            }

            $user->save();

            // agar API token use kar rahe ho (Sanctum ya Passport)
            $token = $user->createToken('auth_token')->plainTextToken;

            return response()->json([
                'user' => $user,
                'token' => $token,
                'profile' => $this->profilePayload($user),
                'profile_completion' => $this->calculateProfileCompletion($user),
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Google login failed'
            ]);
        }
    }
}
