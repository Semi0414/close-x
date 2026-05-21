<?php

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

Route::get('/', function () {
    $path = resource_path('views/closex/home.html');

    if (!is_file($path)) {
        abort(404, 'Home page not found.');
    }

    return response(file_get_contents($path), 200, [
        'Content-Type' => 'text/html; charset=UTF-8',
    ]);
});
