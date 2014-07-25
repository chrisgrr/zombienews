class ZombieController < ApplicationController
  
  def home
  	@tweets = $TWITTER.search("#zombies", result_type: "recent").take(20)
  end

  def about
  end

end