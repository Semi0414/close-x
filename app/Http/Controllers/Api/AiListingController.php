<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class AiListingController extends Controller
{
    /**
     * Text / pasted content se AI parsing (WhatsApp / Telegram style).
     */
    public function parseText(Request $request)
    {
        $data = $request->validate([
            'input_text' => 'required|string',
            'language' => 'nullable|string|max:10',
        ]);

        $language = $data['language'] ?? 'auto';

        $parsed = $this->mockParseListing($data['input_text'], $language);

        return response()->json($parsed);
    }

    /**
     * Image / screenshot / document (OCR + AI) – placeholder.
     */
    public function parseImage(Request $request)
    {
        $data = $request->validate([
            'image_url' => 'required|string',
            'language' => 'nullable|string|max:10',
        ]);

        // TODO: integrate real OCR + AI pipeline
        $parsed = $this->mockParseListing(
            'Example extracted text from image at ' . $data['image_url'],
            $data['language'] ?? 'auto'
        );

        return response()->json($parsed);
    }

    /**
     * Voice dictation (speech-to-text already done on client or separate service).
     */
    public function parseVoice(Request $request)
    {
        $data = $request->validate([
            'transcript' => 'required|string',
            'language' => 'nullable|string|max:10',
        ]);

        $parsed = $this->mockParseListing($data['transcript'], $data['language'] ?? 'auto');

        return response()->json($parsed);
    }

    /**
     * NOTE: Abhi ke liye yeh dummy parser hai.
     * Baad mein isko OpenAI / custom LLM + prompt se replace karna hai.
     */
    protected function mockParseListing(string $text, string $language): array
    {
        return [
            'language_detected' => $language === 'auto' ? 'en' : $language,
            'quality_score' => 0.8,
            'listings' => [
                [
                    'listing_type' => 'sale',
                    'property_type' => 'apartment',
                    'area' => 'Dubai Marina',
                    'city' => 'Dubai',
                    'beds' => 3,
                    'baths' => 4,
                    'size' => 1800,
                    'price' => 8800000,
                    'currency' => 'AED',
                    'is_off_plan' => false,
                    'status' => 'active',
                    'tags' => ['exclusive', 'urgent'],
                    'notes' => $text,
                    'missing_fields' => [
                        'developer',
                        'exact_project',
                    ],
                ],
            ],
        ];
    }
}


