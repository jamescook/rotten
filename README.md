# Rotten - Parser for the Rotten Tomatoes API


### Usage
    require "rotten"
    Rotten.api_key = 'your_key'

    # Info about a specific film
    movies = Rotten::Movies.search("There will be blood").pop
    movie.reviews
    movie.cast
    
    # list upcoming movies
    Rotten::Movie.upcoming

    # list movies opening this week
    Rotten::Movie.opening

### Features
- Movie search
- Movies opening this week
- Movies upcoming
- Movie reviews

#### TODO
- Implement all APIs
- More tests

#### Copyright

Rotten is licensed under the MIT license.

