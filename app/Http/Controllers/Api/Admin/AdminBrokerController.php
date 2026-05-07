<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\BrokerProfile;
use App\Models\User;
use Illuminate\Http\Request;

class AdminBrokerController extends Controller
{
    public function index()
    {
        return User::with('brokerProfile', 'agency')
            ->where('role', 'broker')
            ->paginate(20);
    }

    public function updateStatus(Request $request, User $user)
    {
        $data = $request->validate([
            'status' => 'required|in:active,suspended,pending',
        ]);

        $user->status = $data['status'];
        $user->save();

        return response()->json($user);
    }

    public function toggleVerified(User $user)
    {
        $profile = $user->brokerProfile ?: new BrokerProfile(['user_id' => $user->id]);
        $profile->verified = !$profile->verified;
        $profile->save();

        return response()->json($profile);
    }
}


