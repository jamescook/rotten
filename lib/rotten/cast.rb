module Rotten
  class Cast
    require "set"
    include Enumerable
    attr_reader :actors
    def initialize array=[]
      @actors     = Set.new
      @characters = []
      process (array || [])
    end

    def inspect
      "<Rotten::Cast actors='#{@actors.map(&:name)}'>"
    end

    def [] index
      @characters[index]
    end

    def process array
      array.each do |hash|
        actor      =  @actors.detect{|a| a.name == hash["name"] } || a=Actor.new; a.attributes=hash
        @actors     << actor
        @characters << [ actor, hash["characters"] ]
      end
    end

    def each &block
      yield @characters
    end

    # Check if this cast includes other Cast or Actor
    # @param [Object other] The target to be compared against.
    # @return [Boolean]
    def include?(other)
      if other.is_a?(Cast)
        names = @actors.map(&:name)
        ( names - other.actors.map(&:name) ).empty?
      elsif other.is_a?(Actor)
        @actors.map(&:name).include?( other.name )
      else
        @characters.include?(other)
      end
    end
  end
end
