<?php

namespace App\Support;

/**
 * Parse compact price tokens from search queries (12k, 22M, 12k AED, $22M USD).
 */
class CompactPriceSearch
{
    /**
     * @return array{text: string, prices: list<array{amount: float, suffix: ?string, currency: ?string}>}
     */
    public static function extract(string $query): array
    {
        $query = trim($query);
        if ($query === '') {
            return ['text' => '', 'prices' => []];
        }

        $words = preg_split('/\s+/', $query) ?: [];
        $prices = [];
        $textParts = [];

        for ($i = 0, $count = count($words); $i < $count; $i++) {
            $word = $words[$i];
            $next = $words[$i + 1] ?? null;

            if (self::isCurrencyToken($word)) {
                continue;
            }

            $withNextCurrency = $next !== null && self::isCurrencyToken($next)
                ? self::parseAmountToken($word)
                : null;

            if ($withNextCurrency !== null) {
                $withNextCurrency['currency'] = self::normalizeCurrency($next);
                $prices[] = $withNextCurrency;
                $i++;

                continue;
            }

            $parsed = self::parseAmountToken($word);
            if ($parsed !== null) {
                $prices[] = $parsed;

                continue;
            }

            $textParts[] = $word;
        }

        return [
            'text' => trim(implode(' ', $textParts)),
            'prices' => $prices,
        ];
    }

    /**
     * @return ?array{amount: float, suffix: ?string, currency: ?string}
     */
    public static function parseAmountToken(string $token): ?array
    {
        $token = trim(str_replace([',', ' '], '', $token));
        if ($token === '') {
            return null;
        }

        $leadingCurrency = null;
        if (preg_match('/^(aed|usd|eur|gbp|\$)(.+)$/i', $token, $prefixMatch)) {
            $leadingCurrency = self::normalizeCurrency($prefixMatch[1]);
            $token = $prefixMatch[2];
        }

        if (preg_match('/^[\$]?\s*([\d]+(?:\.\d+)?)([kmb])$/i', $token, $match)) {
            $spec = self::buildSpec((float) $match[1], strtolower($match[2]));
            if ($leadingCurrency !== null) {
                $spec['currency'] = $leadingCurrency;
            }

            return $spec;
        }

        if (preg_match('/^[\$]?\s*([\d]+(?:\.\d+)?)$/', $token, $match)) {
            $numeric = (float) $match[1];
            if ($numeric < 1000) {
                return null;
            }

            $spec = self::buildSpec($numeric, null);
            if ($leadingCurrency !== null) {
                $spec['currency'] = $leadingCurrency;
            }

            return $spec;
        }

        return null;
    }

    /**
     * @return array{amount: float, suffix: ?string, currency: ?string}
     */
    private static function buildSpec(float $value, ?string $suffix): array
    {
        return match ($suffix) {
            'k' => [
                'amount' => $value * 1_000,
                'suffix' => 'k',
                'currency' => null,
            ],
            'm' => [
                'amount' => $value * 1_000_000,
                'suffix' => 'm',
                'currency' => null,
            ],
            'b' => [
                'amount' => $value * 1_000_000_000,
                'suffix' => 'b',
                'currency' => null,
            ],
            default => [
                'amount' => $value,
                'suffix' => null,
                'currency' => null,
            ],
        };
    }

    private static function isCurrencyToken(string $token): bool
    {
        return self::normalizeCurrency($token) !== null;
    }

    private static function normalizeCurrency(string $token): ?string
    {
        $normalized = strtoupper(trim($token));

        return match ($normalized) {
            '$', 'USD' => 'USD',
            'AED' => 'AED',
            'EUR' => 'EUR',
            'GBP' => 'GBP',
            default => null,
        };
    }
}
