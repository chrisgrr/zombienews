class ZombieController < ApplicationController
  
  def home
    @tweets = $REDIS.get('tweets')
    if @tweets
      @tweets = JSON.parse(@tweets)
    else
      @tweets = $TWITTER.search("#zombies", result_type: "recent").take(20)
      @tweets = @tweets.map do |tweet|
        {
          'user_profile_image' => tweet.user.profile_image_url,
          'text' => tweet.text,
          'user_name' => tweet.user.name,
          'screen_name' => tweet.user.screen_name,
          'created_at' => tweet.created_at.to_s,
          'url' => tweet.url.to_s,
        }
      end
      $REDIS.set('tweets', @tweets.to_json)
      $REDIS.expire('tweets', 300)
      @tweets = JSON.parse($REDIS.get('tweets'))
    end
  end

  def about
  end
end