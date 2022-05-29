<?php

namespace App\Console\Commands;

use App;
use Carbon\Carbon;
use Exception;
use Goutte\Client as GoutteClient;
use GuzzleHttp\Client as GuzzleClient;
use Illuminate\Console\Command;

class GetMediaStackNews extends Command
{
    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Get the news of MediaStack';
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'mediastack:get';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return void
     */
    public function handle()
    {
        setlocale(LC_ALL, config('app.php_locale'));
        App::setLocale(config('app.locale'));
        Carbon::setLocale(config('app.locale'));

        $mediaStackKey = config('mediastack.key');
        $mediaStackUri = config('mediastack.uri');

        if (
            in_array(null, [$mediaStackKey, $mediaStackUri]) &&
            in_array('', [trim($mediaStackKey), trim($mediaStackUri)])
        ) {
            throw new Exception('One MediaStack ENV parameters was empty or null at least.');
        }

        $guzzleClient = new GuzzleClient();
        $api_response = $guzzleClient->request('GET', $mediaStackUri, [
            'query' => [
                'access_key' => $mediaStackKey,
                'countries'  => 'fr',
                'sources'    => 'lepoint',
                'limit'      => 20,
            ],
        ]);

        if (200 != $api_response->getStatusCode()) {
            throw new Exception('Status code was not 200');
        }

        $api_response = json_decode($api_response->getBody()->getContents());

        if (empty($api_response->data)) {
            throw new Exception('Empty response');
        }

        collect($api_response->data)
            ->each(function ($item) {
                $goutteClient = new GoutteClient();
                $crawler      = $goutteClient->request('GET', $item->url);

                $text = $crawler->filter('.ArticleBody')->text();
            });
    }
}
