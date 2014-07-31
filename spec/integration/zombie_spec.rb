require 'rails_helper'

describe "Zombie Pages" do

  before do
    $TWITTER.stub(:search).and_return([])
    $REDIS.stub(:get).with('tweets').and_return(nil)
    $REDIS.stub(:set).and_return(nil)
    $REDIS.stub(:expire).and_return(nil)
  end

  describe "Home Page" do
    describe "Content" do
      it "says Zombie News" do
        visit '/'
        expect(page).to have_content("Zombie News")
      end
    end

    describe "Tweets" do
      let(:tweets) do
        [
          double(Twitter::Tweet, 
            user: double(Twitter::User,
              profile_image_url: "http://pbs.twimg.com/profile_images/535346344/m15DoO_n_normal.jpeg",
              name: 'Larry the Zombie',
              screen_name: 'larry_the_zombie'
            ),
            created_at: Time.now,
            text: "Hey guys — check out this awesome brain shop!",
            url: "www.twitter.com/larry_the_zombie/status/491698257966665728"
          ),
          double(Twitter::Tweet, 
            user: double(Twitter::User,
              profile_image_url: "http://pbs.twimg.com/profile_images/65432223455/m15DoO_n_normal.jpeg",
              name: 'Laszlo the Ghoul',
              screen_name: 'laszlo_the_ghoul'
            ),
            created_at: Time.now,
            text: "Just made some great ghoulash!",
            url: "www.twitter.com/laszlo_the_ghoul/status/098765434567890"
          )
        ]
      end

      before do
        $TWITTER.stub(:search).with("#zombies", result_type: "recent").and_return(tweets)
      end

      it 'shows a list of tweets' do
        visit '/'
        tweets.each do |tweet|
          expect(page).to have_content(tweet.text)
        end
      end

      it 'shows the author of each tweet' do
        visit '/'
        tweets.each do |tweet|
          expect(page).to have_content(tweet.user.name)
        end
      end

      it 'has a link to the tweet' do
        visit '/'
        tweets.each do |tweet|
          expect(page).to have_css("a[href~='#{tweet.url}']")
        end
      end
    end
  end

  describe "About Page" do
    describe "Content" do
      it "should have the content About Zombie News" do
        visit '/about'
        expect(page).to have_content("About Zombie News")
      end
    end
  end
end