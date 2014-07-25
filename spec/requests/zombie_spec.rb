require 'rails_helper'

describe "Zombie Pages" do

  describe "Home Page" do

	describe "GET Home Page" do

	  it "should load the page" do
	    get root_path
	    response.status.should be(200)
	  end
	end

    describe "Content" do

      before { visit root_path }

  	  it "should have the content Zombie News" do
  	    expect(page).to have_content("Zombie News")
  	  end
    end

    describe "Tweets" do

 	  it "should return an array" do
 	  	tweet = $TWITTER.search("#zombies", :result_type => "recent").take(20)
 	  	expect(tweet).to be_a Array
 	  end
 	end
  end

  describe "About Page" do

  	describe "Content" do

  	  before { visit about_path }

  	  it "should have the content About Zombie News" do
		expect(page).to have_content("About Zombie News")
  	  end
  	end
  end
end

#Testing tweets tweets.should respond_to(methods) - I think this is the way to go?