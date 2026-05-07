<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Agency;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rule;

class ProfileController extends Controller
{
    private function profileCompletionNote(array $missingFields): string
    {
        if (empty($missingFields)) {
            return 'Profile completion is 100%. All required fields are filled.';
        }

        return 'Profile completion is not 100% because these required fields are missing: ' . implode(', ', $missingFields) . '.';
    }

    private function profileCompletionDetails($user): array
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

    private function calculateProfileCompletionPercent($user): int
    {
        return $this->profileCompletionDetails($user)['percent'];
    }

    private function updateProfileCompletionPercent($user): int
    {
        $percent = $this->calculateProfileCompletionPercent($user);
        $user->profile_completion_percent = $percent;
        $user->save();

        return $percent;
    }

    private function calculateProfileCompletion($user): string
    {
        $percent = $this->calculateProfileCompletionPercent($user);
        return $percent . '%';
    }

    private function storePublicFile(UploadedFile $file, string $directory): string
    {
        $path = $file->store($directory, 'public');

        return Storage::url($path);
    }

    /**
     * Unified profile payload for app.
     */
    private function profilePayload($user)
    {
        $user->loadMissing(['agency', 'brokerProfile']);
        $agency = $user->agency;
        $brokerProfile = $user->brokerProfile;
        $completionDetails = $this->profileCompletionDetails($user);

        return [
            'id' => $user->id,
            'first_name' => $user->first_name,
            'last_name' => $user->last_name,
            'phone' => $user->phone,
            'email' => $user->email,
            'status' => $user->status,
            'profile_picture' => $user->profile_photo,
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
            'agency_orn_no' => $agency?->orn,
            'agency_ded_license_no' => $agency?->ded_license,
            'agency_city' => $agency?->city,
            'agency_phone_no' => $agency?->phone,
            'agency_whatsapp_no' => $agency?->whatsapp,
            'agency_email' => $agency?->email,
            'agency' => $agency ? [
                'agency_name' => $agency->name,
                'agency_logo' => $agency->logo,
                'agency_address' => $agency->address,
                'agency_orn_no' => $agency->orn,
                'agency_ded_license_no' => $agency->ded_license,
                'agency_city' => $agency->city,
                'agency_phone_no' => $agency->phone,
                'agency_whatsapp_no' => $agency->whatsapp,
                'agency_email' => $agency->email,
                'attachments' => $agency->attachments ?? [],
            ] : null,
            'user' => $user,
        ];
    }

    /**
     * Broker ka current profile + agency + trust signals.
     */
    public function me(Request $request)
    {
        $user = $request->user()->load(['brokerProfile', 'agency']);

        return response()->json($this->profilePayload($user));
    }

    /**
     * GET edit profile data.
     */
    public function getEditProfile(Request $request)
    {
        $user = $request->user()->load(['agency', 'brokerProfile']);

        return response()->json($this->profilePayload($user));
    }

    /**
     * POST edit profile data.
     */
    public function editProfile(Request $request)
    {
        $user = $request->user()->load(['agency', 'brokerProfile']);

        $data = $request->validate([
            'profile_picture' => 'sometimes|nullable',
            'first_name' => 'sometimes|nullable|string|max:255',
            'last_name' => 'sometimes|nullable|string|max:255',
            'phone' => ['sometimes', 'nullable', 'string', 'max:20', Rule::unique('users', 'phone')->ignore($user->id)],
            'phone_notifications' => 'sometimes|boolean',
            'messages_notifications' => 'sometimes|boolean',
            'whatsapp_notifications' => 'sometimes|boolean',
            'account_type' => 'sometimes|in:personal,agency',
            'brn_no' => 'sometimes|nullable|string|max:100',
            'short_bio' => 'sometimes|nullable|string',
            'agency_name' => 'required_if:account_type,agency|nullable|string|max:255',
            'agency_logo' => 'sometimes|nullable',
            'agency_address' => 'sometimes|nullable|string|max:255',
            'agency_orn_no' => 'sometimes|nullable|string|max:100',
            'agency_ded_license_no' => 'sometimes|nullable|string|max:100',
            'agency_city' => 'sometimes|nullable|string|max:255',
            'agency_phone_no' => 'sometimes|nullable|string|max:50',
            'agency_whatsapp_no' => 'sometimes|nullable|string|max:50',
            'attachments' => 'sometimes|array',
            'attachments.*' => 'nullable',
            'agency_email' => 'required_if:account_type,agency|nullable|email|max:255',
        ]);

        $effectiveAccountType = $data['account_type'] ?? ($user->account_type ?? 'personal');
        if ($effectiveAccountType === 'agency' && !$request->filled('agency_email') && empty(optional($user->agency)->email)) {
            return response()->json([
                'message' => 'The agency email field is required for agency account.',
                'errors' => [
                    'agency_email' => ['The agency email field is required for agency account.'],
                ],
            ], 422);
        }

        if (array_key_exists('profile_picture', $data)) {
            if ($request->hasFile('profile_picture')) {
                $request->validate([
                    'profile_picture' => 'file|image|mimes:jpg,jpeg,png,webp|max:5120',
                ]);
                $user->profile_photo = $this->storePublicFile($request->file('profile_picture'), 'profiles/pictures');
            } elseif (is_string($data['profile_picture']) || is_null($data['profile_picture'])) {
                $user->profile_photo = $data['profile_picture'];
            }
        }
        if (array_key_exists('first_name', $data)) {
            $user->first_name = $data['first_name'];
        }
        if (array_key_exists('last_name', $data)) {
            $user->last_name = $data['last_name'];
        }
        if (array_key_exists('phone', $data)) {
            $user->phone = $data['phone'];
        }
        if (array_key_exists('phone_notifications', $data)) {
            $user->phone_notifications = (bool) $data['phone_notifications'];
        }
        if (array_key_exists('messages_notifications', $data)) {
            $user->messages_notifications = (bool) $data['messages_notifications'];
        }
        if (array_key_exists('whatsapp_notifications', $data)) {
            $user->whatsapp_notifications = (bool) $data['whatsapp_notifications'];
        }
        if (array_key_exists('account_type', $data)) {
            $user->account_type = $data['account_type'];
        }

        $fullName = trim((string) ($user->first_name ?? '') . ' ' . (string) ($user->last_name ?? ''));
        if ($fullName !== '') {
            $user->name = $fullName;
        }
        $user->save();

        $profileFields = collect($data)->only(['brn_no', 'short_bio'])->toArray();
        if (!empty($profileFields)) {
            $user->brokerProfile()->updateOrCreate(
                ['user_id' => $user->id],
                [
                    'brn_number' => $profileFields['brn_no'] ?? null,
                    'bio' => $profileFields['short_bio'] ?? null,
                ]
            );
        }

        if (($user->account_type ?? 'personal') === 'agency') {
            $agency = $user->agency ?: new Agency();
            $agencyLogo = $agency->logo;
            $attachments = $agency->attachments ?? [];

            if (array_key_exists('agency_logo', $data)) {
                if ($request->hasFile('agency_logo')) {
                    $request->validate([
                        'agency_logo' => 'file|image|mimes:jpg,jpeg,png,webp,svg|max:5120',
                    ]);
                    $agencyLogo = $this->storePublicFile($request->file('agency_logo'), 'profiles/agency/logos');
                } elseif (is_string($data['agency_logo']) || is_null($data['agency_logo'])) {
                    $agencyLogo = $data['agency_logo'];
                }
            }

            if (array_key_exists('attachments', $data)) {
                $incomingAttachments = $data['attachments'];

                if ($request->hasFile('attachments')) {
                    $request->validate([
                        'attachments' => 'array',
                        'attachments.*' => 'file|mimes:jpg,jpeg,png,webp,svg,pdf,doc,docx|max:10240',
                    ]);
                    $stored = [];
                    foreach ($request->file('attachments', []) as $file) {
                        $stored[] = $this->storePublicFile($file, 'profiles/agency/attachments');
                    }
                    $attachments = $stored;
                } elseif (is_array($incomingAttachments)) {
                    $attachments = array_values(array_filter($incomingAttachments, function ($item) {
                        return is_string($item) && $item !== '';
                    }));
                }
            }

            $agency->fill([
                'name' => $data['agency_name'] ?? $agency->name,
                'logo' => $agencyLogo,
                'address' => $data['agency_address'] ?? $agency->address,
                'orn' => $data['agency_orn_no'] ?? $agency->orn,
                'ded_license' => $data['agency_ded_license_no'] ?? $agency->ded_license,
                'city' => $data['agency_city'] ?? $agency->city,
                'phone' => $data['agency_phone_no'] ?? $agency->phone,
                'whatsapp' => $data['agency_whatsapp_no'] ?? $agency->whatsapp,
                'email' => $data['agency_email'] ?? $agency->email,
                'attachments' => $attachments,
            ]);
            $agency->save();

            if (!$user->agency || $user->agency_id !== $agency->id) {
                $user->agency()->associate($agency);
                $user->save();
            }
        }

        $user->load(['agency', 'brokerProfile']);
        $completionPercent = $this->updateProfileCompletionPercent($user);
        $completionDetails = $this->profileCompletionDetails($user);

        return response()->json([
            'message' => 'Profile updated successfully.',
            'data' => $this->profilePayload($user),
            'profile_completion' => $completionPercent . '%',
            'missing_required_fields' => $completionDetails['missing_required_fields'],
            'profile_completion_note' => $this->profileCompletionNote($completionDetails['missing_required_fields']),
        ]);
    }

    /**
     * Personal + broker profile update.
     */
    public function updateProfile(Request $request)
    {
        $user = $request->user();

        $data = $request->validate([
            'first_name' => 'sometimes|nullable|string|max:255',
            'last_name' => 'sometimes|nullable|string|max:255',
            'whatsapp' => 'sometimes|nullable|string|max:50',
            'language' => 'sometimes|string|max:10',
            'profile_photo' => 'sometimes|nullable|string',
            'bio' => 'sometimes|nullable|string',
            'company_name' => 'sometimes|nullable|string|max:255',
            'brn_number' => 'sometimes|nullable|string|max:100',
            'experience_years' => 'sometimes|nullable|integer|min:0',
            'show_whatsapp' => 'sometimes|boolean',
        ]);

        // If first/last is provided, keep `name` consistent for older UI.
        if ($request->filled('first_name') || $request->filled('last_name')) {
            $first = $request->input('first_name', $user->first_name);
            $last = $request->input('last_name', $user->last_name);
            $full = trim(trim((string) $first) . ' ' . trim((string) ($last ?? '')));
            if ($full !== '') {
                $data['name'] = $full;
            }
        }

        $user->fill($data);
        $user->save();

        $profileData = collect($data)->only([
            'bio',
            'company_name',
            'brn_number',
            'experience_years',
            'show_whatsapp',
        ])->toArray();

        if (!empty($profileData)) {
            $user->brokerProfile()
                ->updateOrCreate(
                    ['user_id' => $user->id],
                    $profileData
                );
        }

        $user->load(['agency', 'brokerProfile']);
        $this->updateProfileCompletionPercent($user);

        return response()->json($user);
    }

    /**
     * Agency info create/update.
     */
    public function updateAgency(Request $request)
    {
        $user = $request->user();

        $data = $request->validate([
            'name' => 'required|string|max:255',
            'orn' => 'nullable|string|max:100',
            'ded_license' => 'nullable|string|max:100',
            'address' => 'nullable|string|max:255',
            'city' => 'nullable|string|max:255',
            'email' => 'nullable|email',
            'phone' => 'nullable|string|max:50',
        ]);

        $agency = $user->agency ?: new Agency();
        $agency->fill($data);
        $agency->save();

        if (!$user->agency || $user->agency_id !== $agency->id) {
            $user->agency()->associate($agency);
            $user->save();
        }

        $user->load(['agency', 'brokerProfile']);
        $this->updateProfileCompletionPercent($user);

        return response()->json($agency);
    }

    /**
     * Account delete (soft logical – abhi simple).
     */
    public function deleteAccount(Request $request)
    {
        $user = $request->user();
        $user->tokens()->delete();
        $user->delete();

        return response()->json([
            'message' => 'Account deleted.',
        ]);
    }
}


