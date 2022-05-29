<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ApiData extends Model
{
    /**
     * The attributes that should be mutated to dates.
     *
     * @var array
     */
    protected $dates = [
        'published_at',
    ];

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'title',
        'description',
        'text',
        'image',
        'published_at',
    ];
}
