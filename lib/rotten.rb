lib = File.expand_path('../', __FILE__)
$:.unshift lib unless $:.include?(lib)

module Rotten
  autoload :Api,   "rotten/api"
  autoload :Actor, "rotten/actor"
  autoload :Cast,  "rotten/cast"
  autoload :Movie, "rotten/movie"
end
