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
end
