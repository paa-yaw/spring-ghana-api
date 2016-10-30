require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  before { @client = FactoryGirl.create :client }
  
  describe "POST #create" do 
  	context "with correct credentials create session" do 
  	  before do 
        @credentials = {
    	  email: @client.email,
    	  password: "123456789"
        }
        post :create, { session: @credentials }
      end

    it "successfully" do
      @client.reload
      expect(json_response[:auth_token]).to eq @client.auth_token 
    end

      it { should respond_with 200 }
    end

    context "with incorrect credentials" do 
      before do 
        @invalid_credentials = { 
    	  email: @client.email,
    	  password: "invalidpassword"
    	}
    	post :create, { session: @invalid_credentials }
      end 

      it "unsuccessfully" do
        expect(json_response[:errors]).to eq "Invalid email or password"
      end

      it { should respond_with 422 }
    end
  end

  describe "#DELETE #destroy" do 
  	before do
  	  sign_in @client
  	  @old_token = @client.auth_token
  	  delete :destroy, id: @client.auth_token 
      allow(Devise).to receive(:friendly_token).and_return("anewrandomtoken098")
      @client.generate_auth_token!
  	end

  	it "change in token" do 
      expect(@old_token).not_to eq @client.auth_token
  	end

  	it { should respond_with 204 }
  end
end
