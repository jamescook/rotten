lib = File.expand_path('../../', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "rotten"
require "fakeweb"

RSpec.configure do |config|
  def fixture_path
    File.join( File.dirname(__FILE__), "fixtures" )
  end

  def simulate(path, fixture, options={})
    if options.member?(:page_limit)
      if options[:page_limit].nil?
        options.delete :page_limit
      end
    else
      options.merge!(:page_limit => 50)
    end
    FakeWeb.register_uri(:get, Rotten::Movie.url_for(path, options),
                         :body => File.read( File.join(fixture_path, fixture)) )
  end

  config.before(:each) do
    Rotten.api_key = "1234567890"
  end
end
FakeWeb.allow_net_connect = false

