<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ApiData extends Model
{
    /**
     * The name of the model.
     *
     * @var string
     */
    const TABLE_NAME = 'api_data';

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

    /**
     * The primary key associated with the table.
     *
     * @var string
     */
    protected $primaryKey = 'id';

    /**
     * The database table may be used by the model.
     *
     * @var string
     */
    protected $table = 'api_data';

    /**
     * Get the name for the local image.
     *
     * @return string
     */
    public function getLocalImageAttribute()
    {
        return $this->id.'-'.basename($this->image);
    }
}
