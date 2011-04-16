module Rotten
  class Cast
    require "set"
    include Enumerable
    attr_reader :actors
    def initialize array=[]
      @actors     = Set.new
      @characters = []
      process array
    end

    def inspect
      "<Rotten::Cast actors='#{@actors.map(&:name)}'>"
    end

    def [] index
      @characters[index]
    end

    def first; [0]; end

    def process array
      array.each do |hash|
        actor      =  @actors.detect{|a| a.name == hash["name"] } || Actor.new(hash["name"])
        @actors     << actor
        @characters << [ actor, hash["characters"] ]
      end
    end

    def each &block
      yield @characters
    end
  end
end
