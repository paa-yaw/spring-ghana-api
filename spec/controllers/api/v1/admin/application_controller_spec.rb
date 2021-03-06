require 'rails_helper'

 class Authorization < ActionController::Base
    include Authenticable
 end

RSpec.describe Api::V1::Admin::ApplicationController, type: :controller do

  
  let(:authorization) { Authorization.new }

  subject { authorization }

  describe "#current_admin!" do
    before do
      @admin = FactoryGirl.create :client, admin: true
      api_authorization_headers @admin.auth_token
      allow(authorization).to receive(:current_admin).and_return(@admin)
      allow(authorization).to receive(:request).and_return(request) 
    end 

    it "returns admin from authorization header " do 
      expect(authorization.current_admin.auth_token).to eq @admin.auth_token
    end
  end

  describe "#authenticate_with_token_and_authorize!" do 
    before do
      allow(authorization).to receive(:current_admin).and_return(nil)
      allow(response).to receive(:response_code).and_return(401)
      allow(response).to receive(:body).and_return({"errors": "You must have admin priviledges to be allowed!"}.to_json)
      allow(authorization).to receive(:response).and_return(response)
    end

    it "returns authorization errors in json" do 
      expect(json_response[:errors]).to eq "You must have admin priviledges to be allowed!"
    end

    it { should respond_with 401 }
  end

  describe "#admin_signed_in?" do 

    context "when admin is in session" do 
      before do 
        @admin = FactoryGirl.create :client, admin: true
        api_authorization_headers @admin.auth_token
        allow(authorization).to receive(:current_admin).and_return(@admin)
      end

      it { should be_admin_signed_in }
    end

    context "when admin is not in session" do 
      before do 
        allow(authorization).to receive(:current_admin).and_return(nil)
      end

      it { should_not be_admin_signed_in }
    end
  end
end
