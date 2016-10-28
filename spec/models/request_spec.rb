require 'rails_helper'

RSpec.describe Request, type: :model do
  before { @request = FactoryGirl.create :request }

  subject { @request }

  it { should respond_to :bedrooms }
  it { should respond_to :bathrooms }
  it { should respond_to :living_rooms }
  it { should respond_to :kitchens }
  it { should respond_to :time_of_arrival }
  it { should respond_to :schedule }

  it { should be_valid }

  # validation specs
  @request_attributes = [:bedrooms, :bathrooms, :living_rooms, :kitchens, :time_of_arrival, :schedule]

  @request_attributes.each do |attribute|
    it { should validate_presence_of attribute }
  end

  [:bedrooms, :bathrooms, :living_rooms, :kitchens].each do |attribute|
    it { should validate_numericality_of(attribute).is_greater_than_or_equal_to(0)}	
  end
end
