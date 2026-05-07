<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Http\UploadedFile;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Str;

class AiProductListingGeneratorController extends Controller
{
    /**
     * Proxy request to n8n webhook and return upstream response.
     */
    public function generate(Request $request)
    {
        $normalizedInputText = $this->normalizeInputText($request->input('input_text'));
        if ($normalizedInputText === null) {
            $request->request->remove('input_text');
        } else {
            $request->merge(['input_text' => $normalizedInputText]);
        }

        $validated = $request->validate([
            'source_type' => 'nullable|string|in:text,pdf,image',
            'file_url' => 'nullable|url',
            'image_url' => 'nullable|url',
            'language' => 'nullable|string|max:10',
            'title' => 'nullable|string|max:255',
            'metadata' => 'nullable|array',
            'input_text' => 'nullable',
            'data' => 'nullable|file|max:20480',
            'file' => 'nullable|file|max:20480',
            'image' => 'nullable|file|mimes:jpg,jpeg,png,webp|max:20480',
            'pdf' => 'nullable|file|mimes:pdf|max:20480',
        ]);

        $webhookUrl = (string) config('services.n8n.listing_generator_webhook');

        if ($webhookUrl === '') {
            return response()->json([
                'message' => 'n8n webhook URL is not configured.',
            ], 500);
        }

        if ($request->hasFile('input_text')) {
            $sourceType = $validated['source_type'] ?? null;
            $fileRule = match ($sourceType) {
                'image' => 'file|mimes:jpg,jpeg,png,webp|max:20480',
                'pdf' => 'file|mimes:pdf|max:20480',
                default => 'file|mimes:jpg,jpeg,png,webp,pdf|max:20480',
            };
            $request->validate([
                'input_text' => $fileRule,
            ]);
        } else {
            $request->validate([
                'input_text' => 'nullable|string|required_without_all:file_url,image_url,data,file,image,pdf',
            ]);
        }

        try {
            $uploadedFile = $this->extractUploadedFile($request);
            $normalizedPayload = $this->buildN8nPayload($validated, $uploadedFile);

            if ($uploadedFile) {
                $multipartFields = $this->buildN8nMultipartFields($normalizedPayload);
                $upstream = Http::acceptJson()
                    ->timeout(120)
                    ->attach(
                        'input_text',
                        file_get_contents($uploadedFile->getRealPath()),
                        $uploadedFile->getClientOriginalName()
                    )
                    ->post($webhookUrl, $multipartFields);
            } else {
                $upstream = Http::acceptJson()
                    ->timeout(120)
                    ->post($webhookUrl, $normalizedPayload);
            }
        } catch (ConnectionException $e) {
            return response()->json([
                'message' => 'Unable to connect to n8n webhook.',
                'error' => $e->getMessage(),
            ], 502);
        }

        $payload = $upstream->json();
        if (!is_array($payload)) {
            $payload = [
                'raw_response' => $upstream->body(),
            ];
        }

        return response()->json([
            'workflow' => 'AI Product Listing Generator',
            'n8n_status' => $upstream->status(),
            'data' => $payload,
        ], $upstream->successful() ? 200 : $upstream->status());
    }

    private function buildN8nPayload(array $validated, ?UploadedFile $uploadedFile): array
    {
        $sourceType = $validated['source_type'] ?? $this->detectSourceType($validated, $uploadedFile);
        $inputText = $validated['input_text'] ?? null;

        return [
            'request_id' => (string) Str::uuid(),
            'workflow' => 'AI Product Listing Generator',
            'source_type' => $sourceType,
            'content' => [
                'text' => is_string($inputText) ? $inputText : null,
                'file_url' => $validated['file_url'] ?? null,
                'image_url' => $validated['image_url'] ?? null,
            ],
            'options' => [
                'language' => $validated['language'] ?? 'auto',
            ],
            'title' => $validated['title'] ?? null,
            'metadata' => $validated['metadata'] ?? [],
            'submitted_at' => now()->toIso8601String(),
        ];
    }

    private function detectSourceType(array $validated, ?UploadedFile $uploadedFile = null): string
    {
        if ($uploadedFile instanceof UploadedFile) {
            $mime = strtolower((string) $uploadedFile->getMimeType());
            if (str_contains($mime, 'image/')) {
                return 'image';
            }

            return 'pdf';
        }

        if (!empty($validated['image_url'])) {
            return 'image';
        }

        if (!empty($validated['file_url'])) {
            return 'pdf';
        }

        return 'text';
    }

    private function extractUploadedFile(Request $request): ?UploadedFile
    {
        foreach (['input_text', 'data', 'file', 'image', 'pdf'] as $key) {
            if ($request->hasFile($key)) {
                return $request->file($key);
            }
        }

        return null;
    }

    private function buildN8nMultipartFields(array $payload): array
    {
        return array_filter([
            'request_id' => $payload['request_id'] ?? null,
            'workflow' => $payload['workflow'] ?? null,
            'source_type' => $payload['source_type'] ?? null,
            'input_text' => $payload['content']['text'] ?? null,
            'file_url' => $payload['content']['file_url'] ?? null,
            'image_url' => $payload['content']['image_url'] ?? null,
            'language' => $payload['options']['language'] ?? null,
            'title' => $payload['title'] ?? null,
            'metadata' => isset($payload['metadata']) ? json_encode($payload['metadata']) : null,
            'submitted_at' => $payload['submitted_at'] ?? null,
        ], function ($value) {
            return $value !== null;
        });
    }

    private function normalizeInputText($value): ?string
    {
        if (is_string($value)) {
            $value = trim($value);
            return $value === '' ? null : $value;
        }

        if (is_array($value)) {
            // Some multipart clients send empty input_text as [] / [""].
            $parts = array_values(array_filter(array_map(function ($item) {
                if (!is_scalar($item)) {
                    return null;
                }

                $text = trim((string) $item);
                return $text === '' ? null : $text;
            }, $value)));

            if (count($parts) === 0) {
                return null;
            }

            return implode("\n", $parts);
        }

        if (is_scalar($value)) {
            $value = trim((string) $value);
            return $value === '' ? null : $value;
        }

        return null;
    }
}
