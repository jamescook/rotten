# API behaviors
# Set your API key with:
#   Rotten.api_key = 'your_key'
#
module Rotten

  module Api
    require "json"
    require "open-uri"
    class UndefinedApiKeyError < StandardError; end

    def self.included(base)
      base.send :extend,  ClassMethods
    end

    module ClassMethods

      def endpoint
        "http://api.rottentomatoes.com/api/public/v#{version}"
      end

      def version
        '1.0'
      end

      def get path, options={}
        if Rotten.api_key.nil?
          raise UndefinedApiKeyError, "Please define your API key with #{self}.api_key=(your_key)"
        end

        url = url_for(path, options)
        open( url ) do |response|
          data = JSON.parse(response.read)
          if block_given?
            yield data
          else
            data
          end
        end
      end

      def url_for(path, options={})
        path.gsub! /\.json\Z/, ''
        
        params = ''
        if options.keys.any?
          options.each_pair{|k,v| params << "#{k}=#{URI.escape(v)}&" }
        end
        params.chomp! "&" if params

        "#{endpoint}/#{path}.json?apikey=#{Rotten.api_key}&#{params}"
      end
    end
  end
end
