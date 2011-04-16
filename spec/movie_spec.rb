require "spec_helper"

describe Rotten::Movie do
  context "#cast" do
    before :each do
      simulate_movie_search
      @movie = Rotten::Movie.search("There Will Be Blood").pop
      simulate_full_cast(@movie)
    end

    context "sent :full" do
      it "should return an array" do
        @movie.cast(:full).should be_an_instance_of(Rotten::Cast)
        @movie.cast(:full).should include(@movie.cast(:abridged))
      end 
    end
  end
  
  context ".opening" do
    before :each do
      simulate_movie_openings
    end

    it "should return an array" do
      Rotten::Movie.opening.should be_an_instance_of(Array)
    end 

    it "should contain a movie" do
      Rotten::Movie.opening.first.should be_an_instance_of(Rotten::Movie)
    end

    it "should contain actors in each movie" do
      Rotten::Movie.opening.first.actors.first.should be_an_instance_of(Rotten::Actor)
    end

    it "should contain casts" do
      Rotten::Movie.opening.first.cast.should be_an_instance_of(Rotten::Cast)
    end
  end

  context ".search" do
    before :each do
      simulate_movie_search
    end

    it "should return an array" do
      Rotten::Movie.search("There Will Be Blood").should be_an_instance_of(Array)
    end 

    it "should contain a movie" do
      Rotten::Movie.search("There Will Be Blood").first.should be_an_instance_of(Rotten::Movie)
    end
  end

  context "when api_key is undefined" do
    it "should raise error" do
      simulate_movie_openings
      Rotten.api_key = nil
      lambda{ Rotten::Movie.opening }.should raise_error(Rotten::Api::UndefinedApiKeyError)
    end 
  end
end
