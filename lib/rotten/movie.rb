module Rotten
  class Movie < Entity
    class InvalidSearchQueryError < StandardError; end
    include Api

    class << self
      def opening options={}
        fetch "lists/movies/opening", options
      end

      def upcoming options={}
        fetch "lists/movies/upcoming", options
      end

      def dvd_releases options={}
        fetch "lists/dvds/new_releases", options
      end

      def in_theaters options={}
        fetch "lists/movies/in_theaters", options
      end
      alias_method :in_theatres, :in_theaters

      def search phrase, options={}
        options.delete :q
        options[:q] = phrase

        fetch "movies/search", options
      end

      def extract_movie_info json={}
        if json.is_a?(Array)
          json.map{|m| extract_movie_info(m) }
        else
          return Movie.new(json)
        end
      end

      protected
      def fetch path, options, json_start="movies"
        result = get(path, options) do |json|
          extract_movie_info(json[json_start])
        end
      end
    end

    attr_reader :actors, :cast
    def initialize movie_hash={}
      super
      @actors = []
      process movie_hash
    end

    def inspect 
      "<Rotten::Movie title='#{title}' id='#{id}'>"
    end

    def to_s
      title
    end

    # Moview reviews
    # @return [Array]
    def reviews options={}
      Movie.get "movies/#{id}/reviews", options do |json|
        json["reviews"].map{|review| Review.from_json(review) }
      end
    end

    # Show cast 
    #
    # @param [Symbol #kind]  Defaults to :abridged, but can accept :full to retrieve full cast info.
    # @return [Rotten::Cast]
    def cast( kind = :abridged )
      if kind == :full
        Movie.get "movies/#{id}/cast" do |json|
          @cast = Cast.new json["cast"]
        end
        self.cast
      else
        @cast
      end
    end

    def process hash
      attributes= hash
      @cast       = Cast.new( abridged_cast )
      @actors     = @cast.actors
    end

    # Fetch updated, potentially additional movie information
    # @return [Rotten::Movie]
    def reload
      return false unless id
      Movie.get "movies/#{id}" do |json|
        process json 
      end
      self
    end
  end
end
