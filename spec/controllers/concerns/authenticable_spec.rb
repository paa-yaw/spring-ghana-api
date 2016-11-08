require "rails_helper"

class Authentication < ActionController::Base
  include Authenticable
end

describe Authentication do 
  let(:authentication) { Authentication.new }

  subject { authentication }

  context "#current_client" do 
    before do
      @client = FactoryGirl.create :client
      api_authorization_headers @client.auth_token
      allow(authentication).to receive(:request).and_return(request)
      allow(authentication).to receive(:current_client).and_return(@client) 
    end

    it "returns client from authorization header " do 
      expect(authentication.current_client.auth_token).to eq @client.auth_token
      expect(authentication.current_client).to eq @client
    end
  end

  context "authenticate with token" do 
    before do
      @client = FactoryGirl.create :client
      allow(authentication).to receive(:current_client).and_return(nil)
      allow(response).to receive(:response_code).and_return(401)
      allow(response).to receive(:body).and_return({"errors" => "Not Authenticated!"}.to_json)
      allow(authentication).to receive(:response).and_return(response) 
    end

    it "returns authentication errors in json" do 
      expect(json_response[:errors]).to eq "Not Authenticated!"	
    end

    it { should respond_with 401 }
  end

  describe "#client_signed_in?" do 

    context "for client in session" do 
      before do
        @client = FactoryGirl.create :client
        api_authorization_headers @client.auth_token
        allow(authentication).to receive(:current_client).and_return(@client)
      end

      it { should be_client_signed_in }
    end

    context "for client not in session" do
      before do 
        allow(authentication).to receive(:current_client).and_return(nil)
      end

      it { should_not be_client_signed_in }
    end
  end


   describe "#current_worker" do 
    before do 
      @worker = FactoryGirl.create :worker 
      api_authorization_headers @worker.auth_token
      allow(authentication).to receive(:request).and_return(request)
      allow(authentication).to receive(:current_worker).and_return(@worker)
    end

    it "returns worker from authentication header" do 
      expect(authentication.current_worker.auth_token).to eq @worker.auth_token
    end
  end


  describe "authenticate_worker_with_token!" do 
    before do 
      @worker = FactoryGirl.create :worker
      allow(authentication).to receive(:current_worker).and_return(nil)
      allow(response).to receive(:response_code).and_return(401)
      allow(response).to receive(:body).and_return({"errors"=> "Not Authenticated!"}.to_json)
      allow(authentication).to receive(:response).and_return(response)
    end

    it "returns authentication errors in json" do 
      expect(json_response[:errors]).to eq "Not Authenticated!"
    end

    it { should respond_with 401 }
  end

  describe "#worker_signed_in?" do 

    context "when worker is in session" do 
      before do
        @worker = FactoryGirl.create :worker
        api_authorization_headers @worker.auth_token
        allow(authentication).to receive(:current_worker).and_return(@worker)
      end

    it { should be_worker_signed_in }
    end

    context "when worker is not in session" do
      before do 
        allow(authentication).to receive(:current_worker).and_return(nil)
      end

      it { should_not be_worker_signed_in }

    end
  end
end