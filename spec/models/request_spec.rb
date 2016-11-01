require 'rails_helper'

RSpec.describe Request, type: :model do
  before { @request = FactoryGirl.create :request }

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
      @request2 = FactoryGirl.create :request, time_of_arrival: (DateTime.now) - rand(365).days 
      @request3 = FactoryGirl.create :request, time_of_arrival: (DateTime.now) - rand(365).days  
      @request4 = FactoryGirl.create :request, time_of_arrival: @time
    end

    context "returns requests by kitchen number" do 
      it "as an array" do
        expect(Request.recent(@time).sort).to match_array([@request4])
      end
    end
  end
end
