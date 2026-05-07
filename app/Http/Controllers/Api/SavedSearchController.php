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

        $data = $request->validate([
            'name' => 'nullable|string|max:255',
            'filters' => 'required|array',
            'alerts_enabled' => 'boolean',
        ]);

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

        $data = $request->validate([
            'name' => 'sometimes|nullable|string|max:255',
            'filters' => 'sometimes|array',
            'alerts_enabled' => 'sometimes|boolean',
        ]);

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

        $paginator = $query->paginate(20);
        $this->listingQuery->transformPaginatorCollection($paginator, $request->user());

        return $paginator;
    }

    private function assertOwner(Request $request, SavedSearch $savedSearch): void
    {
        if ($savedSearch->user_id !== $request->user()->id) {
            abort(403, 'You do not own this saved search.');
        }
    }
}
