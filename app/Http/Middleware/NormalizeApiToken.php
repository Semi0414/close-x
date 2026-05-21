<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class NormalizeApiToken
{
    /**
     * Normalize token headers for clients not sending Authorization: Bearer.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next)
    {
        if (!$request->bearerToken()) {
            $candidates = [
                $request->header('token'),
                $request->header('access_token'),
                $request->input('token'),
                $request->input('access_token'),
            ];

            foreach ($candidates as $token) {
                if (!is_string($token)) {
                    continue;
                }

                $token = trim($token);
                if ($token === '') {
                    continue;
                }

                $request->headers->set('Authorization', 'Bearer ' . $token);
                break;
            }
        }

        return $next($request);
    }
}

