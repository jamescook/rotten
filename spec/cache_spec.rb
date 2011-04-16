require "spec_helper"

describe Rotten::Cache do
  context ".new" do
    context "when :store is not given" do
      it "should set the store to SimpleCache" do
        Rotten::Cache.new.store.class.should == Rotten::SimpleCache 
      end
    end
  end

  context "#read" do
    before :each do
      @cache = Rotten::SimpleCache.new
      @cache.write :name, "bob"
    end

    context "given a key" do
      it "should read the key from the cache" do
        @cache.read(:name).should == "bob"
        YAML.load(@cache.cache_file).should == {"name" => "bob"}
      end
    end
  end

  context "#write" do
    before :each do
      @cache = Rotten::SimpleCache.new
      @cache.write :name, "hank"
    end
    context "given a key/value" do
      it "should write the data to the cache"  do
        YAML.load(@cache.cache_file).should == {"name" => "hank"}
      end
    end
  end

  context "hooked into Rotten::Movie" do
    before :each do
      Rotten::Movie.enable_cache!
      simulate "movies/search", "search.json", :q => "There Will Be Blood"
      #TODO figure out how open uri uses Net::HTTP for better tests
      Net::HTTP.stub(:open){ raise }
      Net::HTTP.stub(:start){ raise }
      Net::HTTP.stub(:get){ raise }
    end

    it "should fetch from the cache" do
      Rotten::Movie.search("There Will Be Blood").should be_an_instance_of(Array)
      json = JSON.parse(File.read( File.join(fixture_path, "search.json") ) )
      YAML.load(Rotten::Movie.cache.cache_file)["http://api.rottentomatoes.com/api/public/v1.0/movies/search.json?apikey=1234567890&q=There%20Will%20Be%20Blood"]["movies"].should ==  json["movies"]
    end
  end
end
