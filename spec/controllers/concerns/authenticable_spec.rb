require "rails_helper"

class Authentication < ActionController::Base
  include Authenticable
end

describe Authentication do
  
  let(:authentication) { Authentication.new }

  subject { authentication }
  
  context "#current_user" do
    before do 
      @client = FactoryGirl.create :client
      allow(authentication).to receive(:current_user).and_return(@client)
    end	
  end

end