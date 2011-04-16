# Capture JSON responses and re-use them
# Works with any cache store that accepts the "read" and "write" methods
# TODO method_missing should hit the @store

module Rotten
  autoload :SimpleCache, "rotten/simple_cache.rb"

  class Cache

    attr_reader :store
    def initialize options={}
      @store = options.delete(:store) || SimpleCache.new(options)
    end

    def read key
      @store.read key
    end
    alias_method :get, :read

    def write key, value
      @store.write key, value
    end
    alias_method :set, :write
  end
end
