require 'rails_helper'



RSpec.describe ZombieController, :type => :controller do
  describe 'home' do
    let(:tweets) do
      [{
        'user_profile_image' => "http://pbs.twimg.com/profile_images/535346344/m15DoO_n_normal.jpeg",
        'text' => 'Hey guys — check out this awesome brain shop!',
        'user_name' => 'Larry the Zombie',
        'screen_name' => 'larry_the_zombie',
        'created_at' => Date.parse('2014-01-01').to_s,
        'url' => "https://twitter.com/larry_the_zombie/status/491698257966665728"
      },{
        'user_profile_image' => "http://pbs.twimg.com/profile_images/65432223455/m15DoO_n_normal.jpeg",
        'text' => 'Just made some great ghoulash!',
        'user_name' => 'Laszlo the Ghoul',
        'screen_name' => 'laszlo_the_ghoul',
        'created_at' => Date.parse('2014-01-01').to_s,
        'url' => "https://twitter.com/laszlo_the_ghoul/status/098765434567890"
        }
      ]
    end

    let(:twitter_client_response) do
      [
        double(Twitter::Tweet, 
          user: double(Twitter::User,
            profile_image_url: "http://pbs.twimg.com/profile_images/535346344/m15DoO_n_normal.jpeg",
            name: 'Larry the Zombie',
            screen_name: 'larry_the_zombie'
          ),
          created_at: Date.parse('2014-01-01'),
          text: "Hey guys — check out this awesome brain shop!",
          url: "https://twitter.com/larry_the_zombie/status/491698257966665728"
        ),
        double(Twitter::Tweet, 
          user: double(Twitter::User,
            profile_image_url: "http://pbs.twimg.com/profile_images/65432223455/m15DoO_n_normal.jpeg",
            name: 'Laszlo the Ghoul',
            screen_name: 'laszlo_the_ghoul'
          ),
          created_at: Date.parse('2014-01-01'),
          text: "Just made some great ghoulash!",
          url: "https://twitter.com/laszlo_the_ghoul/status/098765434567890"
        )
      ]
    end

    before do
      $REDIS.stub(:get).with('tweets').and_return(nil)

      $TWITTER.stub(:search).
        with("#zombies", result_type: "recent").
        and_return(double('response', take: twitter_client_response))
    end

    it "renders the home template" do
      get :home
      expect(response).to render_template("home")
    end

    it "returns 200 OK" do
      get :home
      expect(response.status).to eq(200)
    end

    context 'when there are no cached tweets' do
      it "fetches recent tweets with the hashtag #zombies" do
        expect($TWITTER).to receive(:search).with("#zombies", result_type: "recent")
        get :home
      end

      it 'saves the tweets in the cache' do
        expect($REDIS).to receive(:set).with('tweets', tweets.to_json, expires_in: 5.minutes)
        get :home
      end

      it "assigns @tweets" do
        get :home
        expect(assigns(:tweets)).to eq(tweets)
      end
    end

    context 'when there are cached tweets' do
      before do
        $REDIS.stub(:get).with('tweets').and_return(tweets.to_json)
      end

      it "does not fetch recent tweets with the hashtag #zombies" do
        expect($TWITTER).not_to receive(:search)
        get :home
      end

      it "assigns @tweets" do
        get :home
        expect(assigns(:tweets)).to eq(tweets)
      end
    end
  end
end
