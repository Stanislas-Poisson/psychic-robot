<?php

namespace App\Http\Controllers;

use App\Models\ApiData;
use Illuminate\Http\Request;

class NewsController extends Controller
{
    /**
     * Return bunch of Data.
     *
     * @return \Illuminate\Database\Eloquent\Collection<App\Models\ApiData>
     */
    public function index(Request $request)
    {
        return ApiData::select('id', 'title', 'description', 'image')
            ->get()
            ->each->setAppends(['local_image']);
    }

    /**
     * Return the required ID.
     */
    public function show(Request $request, int $apiDataId): ApiData
    {
        return ApiData::findOrFail($apiDataId);
    }
}
