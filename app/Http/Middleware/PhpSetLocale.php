<?php

namespace App\Http\Middleware;

use App;
use Carbon\Carbon;
use Closure;
use Illuminate\Http\Request;

class PhpSetLocale
{
    /**
     * Set the locale definied in the env.
     *
     * @return mixed
     */
    public function handle(Request $request, Closure $next)
    {
        setlocale(LC_ALL, config('app.php_locale'));
        App::setLocale(config('app.locale'));
        Carbon::setLocale(config('app.locale'));

        return $next($request);
    }
}
