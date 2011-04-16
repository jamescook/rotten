lib = File.expand_path('../', __FILE__)
$:.unshift lib unless $:.include?(lib)

module Rotten
  autoload :Entity, "rotten/entity"
  autoload :Api,    "rotten/api"
  autoload :Actor,  "rotten/actor"
  autoload :Cast,   "rotten/cast"
  autoload :Review, "rotten/review"
  autoload :Movie,  "rotten/movie"

  def api_key=(val)
    @api_key = val
  end

  def api_key
    @api_key
  end
  module_function :api_key=, :api_key
end
