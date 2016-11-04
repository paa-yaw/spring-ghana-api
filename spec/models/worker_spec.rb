require 'rails_helper'

RSpec.describe Worker, type: :model do
  
  before { @worker = FactoryGirl.build :worker }

  subject { @worker }

  @worker_attributes = [:first_name, :last_name, :age, :sex, :phone_number, :location, :experience, :min_wage, :email]

  @worker_attributes.each do |attribute|
    it { should respond_to attribute }
  end

  it { should validate_uniqueness_of(:email) }

  @worker_attributes.delete(:email)

  @attributes_without_email = @worker_attributes

  @attributes_without_email.each do |attribute|
    it { should validate_presence_of attribute }
  end

  it { should be_valid }
end
