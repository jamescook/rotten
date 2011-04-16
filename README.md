# Rotten - Parser for the Rotten Tomatoes API


### Usage
    require "rotten"
    Rotten.api_key = 'your_key'

    # Info about a specific film
    movies = Rotten::Movies.search("There will be blood").pop
    movie.reviews
    movie.cast
    
    # List upcoming movies
    Rotten::Movie.upcoming

    # List movies in theatres now
    Rotten::Movie.in_theatres

    # List movies opening this week
    Rotten::Movie.opening

    # List movies coming to dvd this week
    Rotten::Movie.dvd_release

    # Use a file cache (baked in)
    Rotten::Movie.enable_cache!
    Rotten::Movie.search "What about bob?"  # Hits API
    Rotten::Movie.search "What about bob?"  # Hits on-disk cache

    # Custom cache. Should respond to #read & #write. Recommended over included cache.
    Rotten::Movie.cache= ActiveSupport::Cache::MemoryStore.new
    Rotten::Movie.search "Blue Velvet"  # Hits API
    Rotten::Movie.search "Blue Velvet"  # Hits MemoryStore


### Features
- Movie search
- Movies opening this week
- Movies upcoming
- Movie reviews
- Caching

#### TODO
- Implement all APIs
- More tests

#### Copyright

Rotten is licensed under the MIT license.

