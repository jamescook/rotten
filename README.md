# Rotten - Parser for the Rotten Tomatoes API


### Usage
    require "rotten"
    Rotten.api_key = 'your_key'
    movies = Rotten::Movies.search "There will be blood"

### Features
- Movie search
- Movies opening this week

#### TODO
- Implement all APIs
- More tests
