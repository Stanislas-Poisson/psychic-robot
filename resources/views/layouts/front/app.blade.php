<!doctype html>
<html lang="{{ app()->getLocale() }}">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>@yield('title', config('app.name'))</title>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="{{ mix('css/app.css') }}" rel="stylesheet" type="text/css">
    <meta name="csrf-token" content="{{ csrf_token() }}">
</head>
<body>
    @yield('main')

    <script src="{{ mix('js/app.js') }}"></script>

    @if ('local' === config('app.env') && true === config('app.livereload'))
        <script src="http://localhost:35729/livereload.js"></script>
    @endif

    <script>
        var $buoop = {required:{e:-3,f:-3,o:-3,s:-1,c:-3},insecure:true,unsupported:true,style:"corner",api:2020.09 };
        function $buo_f(){
            var e = document.createElement("script");
            e.src = "//browser-update.org/update.min.js";
            document.body.appendChild(e);
        };
        try {document.addEventListener("DOMContentLoaded", $buo_f,false)}
        catch(e){window.attachEvent("onload", $buo_f)}
    </script>
</body>
</html>
