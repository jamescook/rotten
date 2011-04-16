lib = File.expand_path('../../', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "rotten"
require "fakeweb"

RSpec.configure do |config|
  def fixture_path
    File.join( File.dirname(__FILE__), "fixtures" )
  end

  def simulate_movie_openings
    FakeWeb.register_uri(:get, Rotten::Movie.url_for("lists/movies/opening"),
                         :body => File.read( File.join(fixture_path, "movie_openings.json") ))
  end

  def simulate_movie_search
    FakeWeb.register_uri(:get, Rotten::Movie.url_for("movies/search", :q => "There Will Be Blood"), 
                         :body => File.read( File.join(fixture_path, "search.json") ))
  end

  def simulate_movie_reviews(movie)
    FakeWeb.register_uri(:get, Rotten::Movie.url_for("movies/#{movie.id}/reviews"), 
                         :body => File.read( File.join(fixture_path, "reviews.json") ))
  end

  def simulate_full_cast(movie)
    FakeWeb.register_uri(:get, Rotten::Movie.url_for("movies/#{movie.id}/cast"),
                         :body => File.read( File.join(fixture_path, "cast.json") ))
  end


  config.before(:each) do
    Rotten.api_key = "1234567890"
  end
end
FakeWeb.allow_net_connect = false

