require 'rails_helper'

RSpec.describe Client, type: :model do
  before { @client = FactoryGirl.create :client }

  subject { @client }

  @client_attributes = [ :email, :password, :password_confirmation, :first_name, :last_name, :location, :auth_token, :admin]

  it { should be_valid }

  # response specs of attributes

  @client_attributes.each do |attribute|
    it { should respond_to attribute }
  end

  # validation specs

  @validated_attributes = [ :email, :first_name, :last_name, :location, :auth_token ]

  @validated_attributes.each do |attribute|
    it { should validate_presence_of attribute }
  end

  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_uniqueness_of :auth_token }
  it { should validate_confirmation_of :password  }

  # association specs

  it { should have_many :requests }

  describe "test association" do
  	before do 
  	  requests = 5.times { FactoryGirl.create :request, client: @client }
  	end

  	it "raise error for dependent destroy" do 
      requests = @client.requests

      @client.destroy

      requests.each do |request|
        expect(Request.find(request)).to raise_error ActiveRecord::RecordNotFound
      end
  	end
  end

  describe "generate_auth_token!" do 

    it "expect auth_token to be generated" do 
      allow(Devise).to receive(:friendly_token).and_return("randomUNIQUEtoken123")
      @client.generate_auth_token!    	
      expect(@client.auth_token).to eq "randomUNIQUEtoken123"
    end

    it "generates a unique auth_token" do 
      existing_client = FactoryGirl.create :client, auth_token: "randomUNIQUEtoken123"
      @client.generate_auth_token!
      expect(@client.auth_token).not_to eq existing_client.auth_token
    end
  end

  describe "test before callback" do
  	  before { @client = FactoryGirl.build :client }

      it "successfully" do
       expect(@client).to receive(:generate_auth_token!)
       @client.save 
      end
  end
end
