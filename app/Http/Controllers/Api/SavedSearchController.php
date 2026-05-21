<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\SavedSearch;
use App\Services\ListingQueryService;
use Illuminate\Http\Request;

class SavedSearchController extends Controller
{
    public function __construct(
        private ListingQueryService $listingQuery
    ) {
    }

    public function index(Request $request)
    {
        $user = $request->user();

        return SavedSearch::where('user_id', $user->id)
            ->orderByDesc('updated_at')
            ->get();
    }

    public function store(Request $request)
    {
        $user = $request->user();
        $payload = $this->normalizedPayload($request);

        $data = validator($payload, [
            'name' => 'nullable|string|max:255',
            'filters' => 'required|array',
            'alerts_enabled' => 'boolean',
        ])->validate();

        $search = SavedSearch::create([
            'user_id' => $user->id,
            'name' => $data['name'] ?? null,
            'filters' => $data['filters'],
            'alerts_enabled' => $data['alerts_enabled'] ?? true,
        ]);

        return response()->json($search, 201);
    }

    public function show(Request $request, SavedSearch $savedSearch)
    {
        $this->assertOwner($request, $savedSearch);

        return response()->json($savedSearch);
    }

    public function update(Request $request, SavedSearch $savedSearch)
    {
        $this->assertOwner($request, $savedSearch);
        $payload = $this->normalizedPayload($request);

        $data = validator($payload, [
            'name' => 'sometimes|nullable|string|max:255',
            'filters' => 'sometimes|array',
            'alerts_enabled' => 'sometimes|boolean',
        ])->validate();

        $savedSearch->fill($data);
        $savedSearch->save();

        return response()->json($savedSearch);
    }

    public function destroy(Request $request, SavedSearch $savedSearch)
    {
        $this->assertOwner($request, $savedSearch);
        $savedSearch->delete();

        return response()->json(['message' => 'Saved search deleted.']);
    }

    public function toggleAlerts(Request $request, SavedSearch $savedSearch)
    {
        $this->assertOwner($request, $savedSearch);

        $savedSearch->alerts_enabled = !$savedSearch->alerts_enabled;
        $savedSearch->save();

        return response()->json($savedSearch);
    }

    /**
     * Run saved filters against active listings (paginated).
     */
    public function run(Request $request, SavedSearch $savedSearch)
    {
        $this->assertOwner($request, $savedSearch);

        $query = $this->listingQuery->baseListingQuery($request, true);
        $this->listingQuery->applyFiltersArray($query, $savedSearch->filters ?? []);
        $query->orderByDesc('created_at');

        $requestedPage = max(1, (int) $request->query('page', 1));
        $paginator = $query->paginate(20, ['*'], 'page', $requestedPage);
        if (count($paginator->items()) === 0 && $requestedPage > 1 && $paginator->lastPage() > 0) {
            $paginator = $query->paginate(20, ['*'], 'page', $paginator->lastPage());
        }
        $this->listingQuery->transformPaginatorCollection($paginator, $request->user());

        return response()->json([
            'listings' => $paginator->items(),
            'pagination' => [
                'current_page' => $paginator->currentPage(),
                'last_page' => $paginator->lastPage(),
                'per_page' => $paginator->perPage(),
                'total' => $paginator->total(),
                'from' => $paginator->firstItem(),
                'to' => $paginator->lastItem(),
                'has_more_pages' => $paginator->hasMorePages(),
            ],
        ]);
    }

    private function assertOwner(Request $request, SavedSearch $savedSearch): void
    {
        if ($savedSearch->user_id !== $request->user()->id) {
            abort(403, 'You do not own this saved search.');
        }
    }

    /**
     * Support raw JSON requests and stringified "filters" payloads.
     *
     * @return array<string, mixed>
     */
    private function normalizedPayload(Request $request): array
    {
        $payload = $request->all();
        $raw = trim((string) $request->getContent());

        if (empty($payload)) {
            if ($raw !== '') {
                $decoded = json_decode($raw, true);
                if (is_array($decoded)) {
                    $payload = $decoded;
                } elseif (
                    strlen($raw) >= 2 &&
                    $raw[0] === '"' &&
                    substr($raw, -1) === '"'
                ) {
                    // Postman sometimes sends the full body as a quoted string.
                    $unquoted = trim($raw, '"');
                    $unescaped = stripcslashes($unquoted);
                    $decodedWrapped = json_decode($unescaped, true);
                    if (is_array($decodedWrapped)) {
                        $payload = $decodedWrapped;
                    }
                }
            }
        }

        if (isset($payload['filters']) && is_string($payload['filters'])) {
            $decodedFilters = json_decode($payload['filters'], true);
            if (is_array($decodedFilters)) {
                $payload['filters'] = $decodedFilters;
            } else {
                $parsedFilters = $this->parseLooseKeyValueFilters($payload['filters']);
                if (!empty($parsedFilters)) {
                    $payload['filters'] = $parsedFilters;
                }
            }
        }

        if (!isset($payload['filters']) && $raw !== '') {
            $parsedFilters = $this->parseLooseKeyValueFilters($raw);
            if (!empty($parsedFilters)) {
                $payload['filters'] = $parsedFilters;
            }
        }

        return $payload;
    }

    /**
     * Parse "key=value" style filters from malformed JSON-like body strings.
     *
     * @return array<string, mixed>
     */
    private function parseLooseKeyValueFilters(string $raw): array
    {
        $matches = [];
        preg_match('/"filters"\s*:\s*\{(.*?)\}/is', $raw, $matches);
        $filtersBlock = $matches[1] ?? $raw;
        $filtersBlock = trim($filtersBlock);
        if ($filtersBlock === '') {
            return [];
        }

        $lines = preg_split('/[\r\n,]+/', $filtersBlock) ?: [];
        $filters = [];

        foreach ($lines as $line) {
            $line = trim($line);
            $line = trim($line, "{}\"'");
            if ($line === '' || !str_contains($line, '=')) {
                continue;
            }

            [$key, $value] = array_map('trim', explode('=', $line, 2));
            if ($key === '' || $value === '') {
                continue;
            }

            $key = trim($key, "\"' ");
            $value = trim($value, "\"' ");

            if ($key === 'tags') {
                $filters[$key] = collect(explode(',', $value))
                    ->map(fn ($tag) => trim((string) $tag))
                    ->filter()
                    ->values()
                    ->all();
                continue;
            }

            if (is_numeric($value)) {
                $filters[$key] = str_contains($value, '.') ? (float) $value : (int) $value;
                continue;
            }

            $lower = strtolower($value);
            if (in_array($lower, ['true', 'false'], true)) {
                $filters[$key] = $lower === 'true';
                continue;
            }

            $filters[$key] = $value;
        }

        return $filters;
    }
}
