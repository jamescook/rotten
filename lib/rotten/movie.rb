module Rotten
  class Movie
    class InvalidSearchQueryError < StandardError; end
    include Api

    class << self
      def opening options={}
        result = get "lists/movies/opening", options do |json|
          extract_movie_info(json["movies"])
        end
      end

      def search phrase, options={}
        options.delete :q
        options[:q] = phrase

        result = get "movies/search", options do |json|
          extract_movie_info(json["movies"])
        end
      end

      def extract_movie_info json={}
        if json.is_a?(Array)
          json.map{|m| extract_movie_info(m) }
        else
          return Movie.new(json)
        end
      end
    end

    attr_reader :actors, :cast
    def initialize movie_hash={}
      @actors = []
      process movie_hash
    end

    def inspect 
      "<Rotten::Movie title='#{@title}' id='#{@id}'>"
    end

    def to_s
      title
    end

    def process hash
      hash.each_pair{|k,v| instance_variable_set("@#{k}", v); self.class.send(:attr_reader, k.to_sym) }
      @cast   = Cast.new( @abridged_cast )
      @actors = @cast.actors
    end

    def reload
      return false unless @id
      Movie.get "movies/#{@id}" do |json|
        process json 
      end
      self
    end
  end
end