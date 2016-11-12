require 'rails_helper'

RSpec.describe Client, type: :model do
  before { @client = FactoryGirl.build :client }

  subject { @client }

  @client_attributes = [ :email, :password, :password_confirmation, :first_name, :last_name, :location, :auth_token, :admin]

  it { should be_valid }

  # response specs of attributes

  @client_attributes.each do |attribute|
    it { should respond_to attribute }
  end

  # validation specs

  @validated_attributes = [ :email, :first_name, :last_name, :location ]

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
      @client.save
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
      @client.save
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


  describe ".filter_by_first_name" do 
    before do 
      @client1 = FactoryGirl.create :client, first_name: "Derek"
      @client2 = FactoryGirl.create :client, first_name: "Anna"
      @client3 = FactoryGirl.create :client, first_name: "Donald"
    end

    it "should return client 3" do 
      expect(Client.filter_by_first_name("Donald").sort).to match_array([@client3])
    end
  end
  

  describe ".filter_by_last_name" do 
    before do 
      @client1 = FactoryGirl.create :client, last_name: "Trump"
      @client2 = FactoryGirl.create :client, last_name: "Knowles"
      @client3 = FactoryGirl.create :client, last_name: "Johnson"
    end

    it "should return client 1" do 
      expect(Client.filter_by_last_name("Trump").sort).to  match_array([@client1])
    end
  end

  describe ".filter_by_location" do 
    before do 
     @client1 = FactoryGirl.create :client, last_name: "Trump", location: "Accra"
     @client2 = FactoryGirl.create :client, last_name: "Knowles", location: "Accra"
     @client3 = FactoryGirl.create :client, last_name: "Johnson", location: "Kumasi"
   end

   it "should return client1 and client2" do 
     expect(Client.filter_by_location("Accra").sort).to match_array([@client1, @client2])
   end
  end


  describe ".search" do 
    before do 
      @client1 = FactoryGirl.create :client, first_name: "Uzumaki", last_name: "Naruto", location: "Konoha", admin: false
      @client2 = FactoryGirl.create :client, first_name: "Uchiha", last_name: "Sasuke", location: "Konoha", admin: false
      @client3 = FactoryGirl.create :client, first_name: "Gaara", last_name: "Gaara", location: "Hidden Sand Village", admin: false
      @client4 = FactoryGirl.create :client, first_name: "Hatake", last_name: "Kakashi", location: "Konoha", admin: false
      @client5 = FactoryGirl.create :client, first_name: "Jiraiya", last_name: "Sama", location: "Unknown", admin: false
    end

    context "search first name Uzumaki, location Konaha" do 
      it "should return client 1" do
        search_params = { first_name: "Uzumaki", location: "Konoha" } 
        expect(Client.search(search_params).sort).to match_array([@client1]) 
      end
    end

    context "search all members of Konaha" do 
      it "should return client 1, 2, and 4" do 
        search_params = { location: "Konoha" }
        expect(Client.search(search_params).sort).to match_array([@client1, @client2, @client4])
      end
    end

    context "when no params are supplied" do 
      it "should return everything" do 
        expect(Client.search({}).sort).to match_array([@client1, @client2, @client3, @client4, @client5])
      end
    end
  end
end
