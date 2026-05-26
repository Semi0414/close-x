<?php

namespace App\Support;

class CompactCountFormatter
{
    /**
     * Format integer counts for display (e.g. 1500 -> 1.5K, 1200000 -> 1.2M).
     */
    public static function format(int $value): string
    {
        if ($value < 1000) {
            return (string) $value;
        }

        $tiers = [
            ['threshold' => 1_000_000_000_000, 'suffix' => 'T'],
            ['threshold' => 1_000_000_000, 'suffix' => 'B'],
            ['threshold' => 1_000_000, 'suffix' => 'M'],
            ['threshold' => 1_000, 'suffix' => 'K'],
        ];

        foreach ($tiers as $tier) {
            if ($value >= $tier['threshold']) {
                $scaled = $value / $tier['threshold'];
                $formatted = rtrim(rtrim(number_format($scaled, 1, '.', ''), '0'), '.');

                return $formatted . $tier['suffix'];
            }
        }

        return (string) $value;
    }

    /**
     * @return array{count: int, count_formatted: string}
     */
    public static function payload(int $value): array
    {
        return [
            'count' => $value,
            'count_formatted' => self::format($value),
        ];
    }
}
