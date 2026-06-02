<?php

namespace App\Exceptions;

use Illuminate\Auth\AuthenticationException;
use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpKernel\Exception\HttpExceptionInterface;
use Throwable;

class Handler extends ExceptionHandler
{
    /**
     * A list of the exception types that are not reported.
     *
     * @var array<int, class-string<Throwable>>
     */
    protected $dontReport = [
        //
    ];

    /**
     * A list of the inputs that are never flashed for validation exceptions.
     *
     * @var array<int, string>
     */
    protected $dontFlash = [
        'current_password',
        'password',
        'password_confirmation',
    ];

    /**
     * Register the exception handling callbacks for the application.
     *
     * @return void
     */
    public function register()
    {
        $this->reportable(function (Throwable $e) {
            //
        });
    }

    public function render($request, Throwable $e)
    {
        if ($request instanceof Request && $request->is('api/*')) {
            if ($e instanceof ValidationException) {
                $errors = $e->errors();
                $failedField = array_key_first($errors);
                $firstError = $failedField ? ($errors[$failedField][0] ?? null) : null;

                return response()->json([
                    'message' => $firstError ?? 'The given data was invalid.',
                    'failed_field' => $failedField,
                    'errors' => $errors,
                ], 422);
            }

            if ($e instanceof AuthenticationException) {
                return response()->json([
                    'message' => 'Unauthenticated.',
                ], 401);
            }

            if ($e instanceof HttpExceptionInterface) {
                $status = $e->getStatusCode();
                if ($status === 403) {
                    return response()->json([
                        'message' => $e->getMessage() ?: 'Forbidden.',
                    ], 403);
                }
            }
        }

        return parent::render($request, $e);
    }
}
