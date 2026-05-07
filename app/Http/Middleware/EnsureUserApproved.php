<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class EnsureUserApproved
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function handle(Request $request, Closure $next)
    {
        $user = $request->user();

        if (!$user) {
            return $next($request);
        }

        if ($user->status === 'suspended') {
            return response()->json([
                'message' => 'Account suspended. Please contact support.',
            ], 403);
        }

        if ($user->status === 'pending' && !$request->isMethod('GET')) {
            return response()->json([
                'message' => 'Waiting for approval. Your account is read-only.',
            ], 403);
        }

        return $next($request);
    }
}


