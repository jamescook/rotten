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
      base.send :include, InstanceMethods
    end

    module InstanceMethods
    end

    module ClassMethods

      def endpoint
        "http://api.rottentomatoes.com/api/public/v#{version}"
      end

      def version
        '1.0'
      end

      def maximum_per_page
        '50'
      end

      def use_cache?
        @use_cache == true
      end

      def enable_cache!
        @use_cache = true
      end

      def disable_cache!
        @use_cache = false
      end

      def cache
        @cache ||= Cache.new
        @cache.store
      end
     
      # Use your own cache, such as ActiveSupport::Cache::MemoryStore
      def cache=(_cache)
        enable_cache!
        @cache = Cache.new :store => _cache
      end

      def get_from_cache url
        if use_cache?
          cache.read(url)
        end
      end

      def write_to_cache url, data
        cache.write(url, data) if use_cache?
      end

      def get path, options={}
        if Rotten.api_key.nil?
          raise UndefinedApiKeyError, "Please define your API key with Rotten.api_key=(your_key)"
        end

        url    = url_for(path, options)
        cached = get_from_cache(url)
        if cached
          if block_given?
            return yield(cached)
          else
            return cached
          end
        end

        open( url ) do |response|
          data = JSON.parse(response.read)
          write_to_cache url, data
          if block_given?
            yield(data)
          else
            data
          end
        end
      end

      def url_for(path, options={})
        path.gsub! /\.json\Z/, ''
        
        params = ''
        if options.keys.any?
          options.each_pair{|k,v| params << "#{k}=#{URI.escape(v.to_s)}&" }
        end
        params.chomp! "&" if params

        "#{endpoint}/#{path}.json?apikey=#{Rotten.api_key}&#{params}"
      end

      def extract_info klass, json={}
        if json.is_a?(Array)
          json.map{|m| extract_info(klass, m) }
        else
          klass.new(json)
        end
      end

      protected
      def warn_about_unknown_options hash
        known   = [:page_limit, :page, :q, :country, :review_type, :apikey]
        unknown = hash.keys.map{|k| k.to_sym} - known
        if unknown.any?
          puts "[rotten] Unknown API options: #{unknown.join(',')}."
        end
      end
    end
  end
end
