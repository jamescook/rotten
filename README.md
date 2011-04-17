# Rotten - Parser for the Rotten Tomatoes API


### Usage
    require "rotten"
    Rotten.api_key = 'your_key'

    # Info about a specific film
    movies = Rotten::Movies.search("There will be blood")[0]
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

Most API calls return multiple results. They are encapsulated in a SearchResult class. They are instances of Set with some Array sugar added. Example:

    Rotten::Movie.upcoming
    => <Rotten::SearchResult total=14 more='false'>
    Rotten::Movie.upcoming[0]
    => <Rotten::Movie title='Water for Elephants' id='771204250'>
    Rotten::Movie.upcoming.to_a
    => <Rotten::Movie title='Water for Elephants' id='771204250'><Rotten::Movie title (you get the idea)...

    results = Rotten::Movie.search "bob"
    => <Rotten::SearchResult total=242 more='true'>
    results.size
    => 50
    results.next #grab the next 50
    results.size
    => 100

SearchResult works with caching, albeit a little wonky as the URLs are not grouped together.
   
### Features
- Movie search
- Movies opening this week
- Movies upcoming
- Movie reviews
- Caching

#### Copyright

Rotten is licensed under the MIT license.

