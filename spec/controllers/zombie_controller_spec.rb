require 'rails_helper'

RSpec.describe ZombieController, :type => :controller do
  describe 'home' do
      let(:tweets) { double('tweets') }

      before do
        $TWITTER.stub(:search).
          with("#zombies", result_type: "recent").
          and_return(double('response', take: tweets))
      end

    it "assigns @tweets" do
      get :home
      expect(assigns(:tweets)).to eq(tweets)
    end

    it "renders the home template" do
      get :home
      expect(response).to render_template("home")
    end

    it "returns 200 OK" do
      get :home
      expect(response.status).to eq(200)
    end
  end
end
