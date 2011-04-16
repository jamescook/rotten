module Rotten
  require "ostruct"
  class Entity < OpenStruct
    class << self
      def from_json(json)
        e = new
        e.attributes = json
        e
      end
    end

    def attributes= hash={}
      hash.each_pair do |k,v|
        instance_variable_get("@table")[k.to_sym] = v
      end
    end
  end
end
