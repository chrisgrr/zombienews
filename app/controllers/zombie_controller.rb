class ZombieController < ApplicationController
  
  def home
    #cached_tweets = redis.get('tweets')
    #if cached_tweets
     # @tweets = cached_tweets
    #else
  	  @tweets = $TWITTER.search("#zombies", result_type: "recent").take(20)
      #redis.set('tweets', @tweets, expiries: 5.minutes)
      # comments = Pete's redis pseudo code
    end
  end

  def about
  end
#end