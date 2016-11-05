require 'rails_helper'

RSpec.describe Request, type: :model do
  before { @request = FactoryGirl.build :request }

  subject { @request }

  @request_attributes = [:bedrooms, :bathrooms, :living_rooms, :kitchens, :time_of_arrival, :schedule, :client_id]
  

  # response specs of attributes
  @request_attributes.each do |attribute|
    it { should respond_to attribute }
  end

  it { should be_valid }

  # validation specs
  @request_attributes.each do |attribute|
    it { should validate_presence_of attribute }
  end

  [:bedrooms, :bathrooms, :living_rooms, :kitchens].each do |attribute|
    it { should validate_numericality_of(attribute).is_greater_than_or_equal_to(0)}	
  end

  # association specs
  it { should belong_to :client }
  it { should have_and_belong_to_many :workers }


  # testing scopes
  describe ".filter_by_bedroom_number" do
    before do 
      @request1 = FactoryGirl.create :request, bedrooms: 5
      @request2 = FactoryGirl.create :request, bedrooms: 6
      @request3 = FactoryGirl.create :request, bedrooms: 7
      @request4 = FactoryGirl.create :request, bedrooms: 8
    end 

    context "return requests by bedrooms" do 
      it "as an array" do
        expect(Request.filter_by_bedroom_number(7).sort).to match_array([@request3]) 
      end
    end
  end

  describe ".filter_by_bathroom_number" do 
    before do 
      @request1 = FactoryGirl.create :request, bathrooms: 2
      @request2 = FactoryGirl.create :request, bathrooms: 3
      @request3 = FactoryGirl.create :request, bathrooms: 4
      @request4 = FactoryGirl.create :request, bathrooms: 5
    end

    context "returns requests by bathrooms" do 
      it "as an array" do 
        expect(Request.filter_by_bathroom_number(5).sort).to match_array([@request4])
      end
    end
  end

  describe ".filter_by_kitchen_number" do 
    before do
      @request1 = FactoryGirl.create :request, kitchens: 1
      @request2 = FactoryGirl.create :request, kitchens: 2
      @request3 = FactoryGirl.create :request, kitchens: 3
      @request4 = FactoryGirl.create :request, kitchens: 4
    end

    context "returns requests by kitchen number" do 
      it "as an array" do
        expect(Request.filter_by_kitchen_number(4).sort).to match_array([@request4])
      end
    end
  end

  describe ".filter_by_living_room_number" do 
    before do
      @request1 = FactoryGirl.create :request, living_rooms: 1
      @request2 = FactoryGirl.create :request, living_rooms: 2
      @request3 = FactoryGirl.create :request, living_rooms: 3
      @request4 = FactoryGirl.create :request, living_rooms: 4
    end

    context "returns requests by kitchen number" do 
      it "as an array" do
        expect(Request.filter_by_living_room_number(4).sort).to match_array([@request4])
      end
    end
  end

  describe ".filter_by_time_of_arrival" do 
    before do
      @time = Time.now
      @request1 = FactoryGirl.create :request, time_of_arrival: (DateTime.now) - rand(365).days 
      @request2 = FactoryGirl.create :request, time_of_arrival: (DateTime.now) - rand(200).days 
      @request3 = FactoryGirl.create :request, time_of_arrival: (DateTime.now) - rand(100).days  
      @request4 = FactoryGirl.create :request, time_of_arrival: @time
    end

    context "returns requests by kitchen number" do 
      it "as an array" do
        expect(Request.recent).to match_array([@request4, @request3, @request2, @request1])
      end
    end
  end



  describe "range in room numbers" do 
    before do 
      @now = DateTime.now
      @request1 = FactoryGirl.create :request, bedrooms: 4, bathrooms: 5, kitchens: 8, living_rooms: 2, time_of_arrival: (DateTime.now) - rand(365).days
      @request2 = FactoryGirl.create :request, bedrooms: 8, bathrooms: 2, kitchens: 6, living_rooms: 1, time_of_arrival: (DateTime.now) - rand(200).days
      @request3 = FactoryGirl.create :request, bedrooms: 4, bathrooms: 5, kitchens: 8, living_rooms: 2, time_of_arrival: (DateTime.now) - rand(100).days
      @request4 = FactoryGirl.create :request, bedrooms: 9, bathrooms: 3, kitchens: 5, living_rooms: 7, time_of_arrival: @now
    end  

    context "min_bedrooms" do
      it "returns array of requests with bedroom number equal or above" do 
        expect(Request.min_bedrooms(4).sort).to match_array([@request3, @request1, @request2, @request4])
      end
    end

    context "max_bedrooms" do 
      it "returns array of requests with bathroom number equal or below" do 
        expect(Request.max_bedrooms(8).sort).to match_array([@request2, @request3, @request1])
      end
    end

    context "min_bathrooms" do
      it "returns array of requests with bathroom number equal or above" do 
        expect(Request.min_bathrooms(4).sort).to match_array([@request3, @request1])
      end
    end

     context "max_bathrooms" do 
      it "returns array of requests with bathroom number equal or below" do 
        expect(Request.max_bathrooms(8).sort).to match_array([@request2, @request3, @request4, @request1])
      end
    end

    context "min_living_rooms" do
      it "returns array of requests with living room number equal or above" do 
        expect(Request.min_living_rooms(4).sort).to match_array([@request4])
      end
    end

    context "max_living_rooms" do 
      it "returns array of requests with living room number equal or below" do 
        expect(Request.max_living_rooms(8).sort).to match_array([@request2, @request3, @request4, @request1])
      end
    end

    context "min_kitchen_number" do
      it "returns array of requests with number of kitchens equal or above" do 
        expect(Request.min_kitchens(4).sort).to match_array([@request2, @request3, @request4, @request1])
      end
    end

    context "max_kitchen_number" do 
      it "returns array of requests with number of kitchens equal or below" do 
        expect(Request.max_kitchens(8).sort).to match_array([@request2, @request3, @request4, @request1])
      end
    end
  end




  describe ".search" do 
    before do 
      @now = DateTime.now
      @request1 = FactoryGirl.create :request, bedrooms: 4, bathrooms: 5, kitchens: 8, living_rooms: 2, time_of_arrival: (DateTime.now) - rand(365).days
      @request2 = FactoryGirl.create :request, bedrooms: 8, bathrooms: 2, kitchens: 6, living_rooms: 1, time_of_arrival: (DateTime.now) - rand(200).days
      @request3 = FactoryGirl.create :request, bedrooms: 4, bathrooms: 5, kitchens: 8, living_rooms: 2, time_of_arrival: (DateTime.now) - rand(100).days
      @request4 = FactoryGirl.create :request, bedrooms: 9, bathrooms: 3, kitchens: 5, living_rooms: 7, time_of_arrival: @now
    end

    context "when no params are sent" do
      it "returns 4 requests" do 
        expect(Request.search({}).count).to eq 4 
      end

      it "returns all requests" do 
        expect(Request.search({})).to match_array([@request1, @request2, @request3, @request4])
      end 
    end
    
    context "when bedrooms = 4, bathrooms = 5, kitchens = 8, living_rooms = 2" do 
      it "returns 2 requests" do 
        search_hash = { bedrooms: 4, bathrooms: 5, kitchens: 8, living_rooms: 2}
        expect(Request.search(search_hash)).to match_array([@request1, @request3]) 
      end
    end

    context "when no requests found to have matching parameters" do 
      it "returns an empty array" do 
        search_hash = { bedrooms: 10, bathrooms: 10, kitchens: 10, living_rooms: 10 }
        expect(Request.search(search_hash)).to be_empty
      end
    end

    context "for requests with bedroom number ranging from 5 to 10" do
      it "returns 2 requests" do 
        search_hash = { min_bedroom_number: 5, max_bedroom_number: 10 }
        expect(Request.search(search_hash)).to match_array([@request2, @request4])
      end    
    end

    context "for requests with 8 kitchens, bathrooms between 2 and 6" do
      it "returns 2 requests" do
        search_hash = { kitchens: 8, min_bathroom_number: 2, max_bathroom_number: 6 } 
        expect(Request.search(search_hash)).to match_array([@request1, @request3])
      end 
    end

    context "for requests with 1 living room, kitchens between 2 and 6" do
      it "returns 2 requests" do
        search_hash = { living_rooms: 1, min_kitchen_number: 4, max_kitchen_number: 6 } 
        expect(Request.search(search_hash)).to match_array([@request2])
      end 
    end

    context "for requests with 1 bathroom, living rooms between 2 and 6" do
      it "returns 2 requests" do
        search_hash = { bathrooms: 1, min_living_rooms: 2, max_living_rooms: 6 } 
        expect(Request.search(search_hash)).to be_empty
      end 
    end


  end
end
