module Rotten
  class SimpleCache
    attr_reader :cache_file
    def initialize options={}
      require "yaml"
      if options[:cache_path] && File.exists?(options[:cache_path])
        @cache_file = options[:cache_path]
        @data = YAML.load_file @cache_file || {}
      else
        require "tempfile"
        @cache_file = Tempfile.new "__rotten"
        @data = YAML.load_file(@cache_file) || {}
      end
    end

    def read key
      @data[key.to_s]
    end

    def write key, value
      @data[key.to_s] = value
      save_to_disk
    end

    private
    def save_to_disk
      File.open(@cache_file, "w"){|f| f.puts(YAML.dump(@data)) }
    end
  end
end
