<?php

use App\Http\Controllers\NewsController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::prefix('web-api')
    ->group(function () {
        Route::controller(NewsController::class)
            ->group(function () {
                Route::get('/news', 'index');
                Route::get('/new/{ApiData_id}', 'show');
            });
    });

Route::get('/', function () {
    return view('news');
});
Route::get('/{vue_capture?}', function () {
    return view('news');
})
    ->where('vue_capture', '^(?:(?!api).)[\/\w\.-]*');
