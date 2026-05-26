<?php

namespace App\Support;

/**
 * Deduplicate add-post / update form-data JSON (Title vs title, Beds vs rooms.bedrooms, etc.).
 */
class ListingFormDataNormalizer
{
    private const MEDIA_KEYS = [
        'images', 'videos', 'documents', 'attachments', 'media', 'photos', 'files',
        'image', 'video', 'document', 'raw',
    ];

    private const LIFECYCLE_STATUSES = ['active', 'sold', 'rented', 'expired'];

    /**
     * @param  array<string, mixed>  $formData
     * @return array<string, mixed>
     */
    public function normalize(array $formData): array
    {
        $scalars = [];
        $rooms = [];
        $size = [];
        $build = [];
        $price = [];

        foreach ($this->stripMedia($formData) as $rawKey => $value) {
            $key = $this->canonicalKey((string) $rawKey);

            if ($key === 'rooms' && is_array($value)) {
                $rooms = array_replace($rooms, $this->normalizeRoomsArray($value));
                continue;
            }

            if ($key === 'size' && is_array($value)) {
                $size = array_replace($size, $this->normalizeSizeArray($value));
                continue;
            }

            if ($key === 'build' && is_array($value)) {
                $build = array_replace($build, $this->normalizeBuildArray($value));
                continue;
            }

            if ($key === 'price' && is_array($value)) {
                $price = array_replace($price, $this->normalizePriceArray($value));
                continue;
            }

            switch ($key) {
                case 'rooms_bedrooms':
                    $rooms['bedrooms'] = $this->toString($value);
                    break;
                case 'rooms_study':
                    $rooms['study'] = $this->toString($value);
                    break;
                case 'size_sqft':
                    $size['sqft'] = $this->toString($value);
                    break;
                case 'build_type':
                    $build['type'] = $this->toString($value);
                    break;
                case 'price_sp':
                    $price['sp'] = $this->toPrice($value);
                    break;
                case 'price_currency':
                    $price['currency'] = $this->toString($value);
                    break;
                case 'tags':
                    $scalars['tags'] = $this->toTags($value);
                    break;
                case 'notes':
                    $scalars['notes'] = $this->toString($value);
                    break;
                case 'title':
                    if (!isset($scalars['property_type']) || $this->isBlank($scalars['property_type'])) {
                        $scalars['property_type'] = $this->toString($value);
                    }
                    break;
                case 'status':
                    $this->applyStatusField($scalars, $value);
                    break;
                case 'kind':
                    $scalars['kind'] = $this->toString($value);
                    break;
                case 'furnishing':
                case 'unit_type':
                    if (!isset($scalars['furnished']) || $this->isBlank($scalars['furnished'])) {
                        $scalars['furnished'] = $this->toString($value);
                    }
                    break;
                case 'price':
                    if (!isset($price['sp'])) {
                        $price['sp'] = $this->toPrice($value);
                    }
                    break;
                default:
                    $scalars[$key] = $this->normalizeScalar($key, $value);
            }
        }

        $out = array_filter(
            $scalars,
            fn ($value) => $value !== null && $value !== '' && $value !== []
        );

        if ($rooms !== []) {
            $out['rooms'] = $rooms;
        }

        if ($size !== []) {
            $out['size'] = $size;
        }

        if ($build !== []) {
            $out['build'] = $build;
        }

        if ($price !== []) {
            $out['price'] = $price;
        }

        if (isset($out['beds'], $out['rooms']['bedrooms'])
            && (string) $out['beds'] === (string) $out['rooms']['bedrooms']) {
            unset($out['beds']);
        }

        if (isset($out['status'], $out['kind'])
            && strtolower((string) $out['status']) === strtolower((string) $out['kind'])) {
            unset($out['status']);
        }

        if (isset($out['status']) && !$this->isLifecycleStatus($out['status'])) {
            $out['kind'] = $out['kind'] ?? $out['status'];
            unset($out['status']);
        }

        return $out;
    }

    /**
     * @param  array<string, mixed>  $formData
     * @return array<string, mixed>
     */
    private function stripMedia(array $formData): array
    {
        $stripped = [];
        foreach ($formData as $key => $value) {
            if (in_array($this->canonicalKey((string) $key), self::MEDIA_KEYS, true)) {
                continue;
            }
            $stripped[$key] = $value;
        }

        return $stripped;
    }

    private function canonicalKey(string $rawKey): string
    {
        $key = strtolower(trim(str_replace(['-', ' '], '_', $rawKey)));

        return match ($key) {
            'note' => 'notes',
            'tag' => 'tags',
            'description' => 'description',
            'furnishing' => 'furnishing',
            default => $key,
        };
    }

    /**
     * @param  array<string, mixed>  $scalars
     */
    private function applyStatusField(array &$scalars, mixed $value): void
    {
        $text = $this->toString($value);
        if ($text === null) {
            return;
        }

        if ($this->isLifecycleStatus($text)) {
            $scalars['status'] = strtolower($text);
            return;
        }

        if (!isset($scalars['kind']) || $this->isBlank($scalars['kind'])) {
            $scalars['kind'] = $text;
        }
    }

    private function isLifecycleStatus(string $value): bool
    {
        return in_array(strtolower(trim($value)), self::LIFECYCLE_STATUSES, true);
    }

    /**
     * @param  array<string, mixed>  $rooms
     * @return array<string, string>
     */
    private function normalizeRoomsArray(array $rooms): array
    {
        $out = [];
        foreach ($rooms as $k => $v) {
            $nk = $this->canonicalKey((string) $k);
            if ($nk === 'bedrooms' || $nk === 'rooms_bedrooms') {
                $out['bedrooms'] = $this->toString($v) ?? '';
            } elseif ($nk === 'study' || $nk === 'rooms_study') {
                $out['study'] = $this->toString($v) ?? '';
            }
        }

        return array_filter($out, fn ($v) => $v !== '');
    }

    /**
     * @param  array<string, mixed>  $size
     * @return array<string, string>
     */
    private function normalizeSizeArray(array $size): array
    {
        $out = [];
        foreach ($size as $k => $v) {
            $nk = $this->canonicalKey((string) $k);
            if ($nk === 'sqft' || $nk === 'size_sqft') {
                $out['sqft'] = $this->toString($v) ?? '';
            }
        }

        return array_filter($out, fn ($v) => $v !== '');
    }

    /**
     * @param  array<string, mixed>  $build
     * @return array<string, string>
     */
    private function normalizeBuildArray(array $build): array
    {
        $out = [];
        foreach ($build as $k => $v) {
            if ($this->canonicalKey((string) $k) === 'type' || $this->canonicalKey((string) $k) === 'build_type') {
                $out['type'] = $this->toString($v) ?? '';
            }
        }

        return array_filter($out, fn ($v) => $v !== '');
    }

    /**
     * @param  array<string, mixed>  $price
     * @return array<string, mixed>
     */
    private function normalizePriceArray(array $price): array
    {
        $out = [];
        foreach ($price as $k => $v) {
            $nk = $this->canonicalKey((string) $k);
            if ($nk === 'sp' || $nk === 'price_sp') {
                $out['sp'] = $this->toPrice($v);
            } elseif ($nk === 'currency' || $nk === 'price_currency') {
                $out['currency'] = $this->toString($v);
            } elseif ($nk === 'amount') {
                $out['sp'] = $this->toPrice($v);
            }
        }

        return array_filter($out, fn ($v) => $v !== null && $v !== '');
    }

    private function normalizeScalar(string $key, mixed $value): mixed
    {
        if ($key === 'tags') {
            return $this->toTags($value);
        }

        if ($key === 'is_off_plan') {
            return filter_var($value, FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE) ?? (bool) $value;
        }

        if (in_array($key, ['commission', 'roi'], true)) {
            return $this->toDecimal($value);
        }

        if (in_array($key, ['beds', 'baths', 'price'], true) && is_numeric($value)) {
            return str_contains((string) $value, '.') ? (float) $value : (int) $value;
        }

        return $this->toString($value) ?? $value;
    }

    private function toDecimal(mixed $value): ?float
    {
        if ($value === null || $value === '') {
            return null;
        }

        if (is_numeric($value)) {
            return (float) $value;
        }

        if (!is_string($value)) {
            return null;
        }

        $cleaned = preg_replace('/[^0-9.\-]/', '', str_replace(',', '', trim($value)));
        if ($cleaned === '' || $cleaned === '-' || $cleaned === '.') {
            return null;
        }

        return (float) $cleaned;
    }

    /**
     * @return list<string>|null
     */
    private function toTags(mixed $value): ?array
    {
        if (is_array($value)) {
            $tags = array_values(array_filter(array_map(function ($tag) {
                return is_string($tag) ? trim($tag) : null;
            }, $value)));

            return $tags === [] ? null : $tags;
        }

        if (is_string($value) && trim($value) !== '') {
            return array_values(array_filter(array_map('trim', explode(',', $value))));
        }

        return null;
    }

    private function toString(mixed $value): ?string
    {
        if ($value === null) {
            return null;
        }

        if (is_string($value)) {
            $trimmed = trim($value);

            return $trimmed === '' ? null : $trimmed;
        }

        if (is_numeric($value) || is_bool($value)) {
            return (string) $value;
        }

        return null;
    }

    private function toPrice(mixed $value): ?float
    {
        if ($value === null || $value === '') {
            return null;
        }

        if (is_array($value)) {
            $nested = $value['sp'] ?? $value['amount'] ?? null;

            return $nested !== null ? (float) $nested : null;
        }

        return (float) $value;
    }

    private function isBlank(mixed $value): bool
    {
        return $value === null || $value === '' || (is_string($value) && trim($value) === '');
    }
}
