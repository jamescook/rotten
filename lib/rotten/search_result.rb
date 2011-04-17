# Encapsulates APIs that return a 'total'
module Rotten
  require "set"
  class SearchResult < Set
    include Api

    #def initialize url, json={}, start='movies'
    def initialize options={}
      @path   = options[:path]
      @api_options  = options[:api_options] || {}
      @start  = options[:start] || 'movies'
      @json   = options[:json]
      @klass  = options[:class]
      @proper = @klass.extract_info(@klass, @json[@start])

      super([@proper].flatten)
    end

    def inspect
      "<Rotten::SearchResult total=#{total} more='#{more?}'>"
    end 

    def total
      @total ||= @json['total'].nil? ? size : @json['total'].to_i
    end

    def more?
      total > size
    end

    # Make the Set more array-like and allow index-based access
    def [](index)
      to_a[index]
    end
    
    # Cache Set#to_a and return it. Calling #next resets it.
    def to_a
      @to_a ||= super.to_a
    end

    def current_page
      @api_options.delete(:page) || 1
    end

    # Fetch additional results, while more exist.
    def next
      if more?
        @api_options.merge! :page => current_page + 1
        @api_options.merge! :page_limit => Movie.maximum_per_page
        @klass.get @path, @api_options do |json|
           [@klass.extract_info(@klass, json[@start])].flatten.each do |x|
             add x
           end
           @to_a = nil
        end
      end
    end
  end
end
