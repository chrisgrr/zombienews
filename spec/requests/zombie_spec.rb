require 'rails_helper'

describe "Home Page" do

  describe "GET Home Page" do

    it "should load the page" do
      get root_path
      response.status.should be(200)
    end
  end

  describe "Content" do

  	it "should have the title Zombie News" do
  	  visit root_path
  	  expect(page).to have_content("Zombie News")
  	end
  end
end
