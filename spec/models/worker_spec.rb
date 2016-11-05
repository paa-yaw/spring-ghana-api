require 'rails_helper'

RSpec.describe Worker, type: :model do
  
  before { @worker = FactoryGirl.build :worker }

  subject { @worker }

  @worker_attributes = [:first_name, :last_name, :age, :sex, :phone_number, :location, :experience, :min_wage, :email, :password,
  	:password_confirmation]


  # validates response to attributes 
  @worker_attributes.each do |attribute|
    it { should respond_to attribute }
  end

  it { should validate_uniqueness_of(:email) }
  it { should validate_confirmation_of :password  }
  it { should validate_length_of(:phone_number).is_equal_to(10) }
  it { should validate_numericality_of(:age).only_integer }




  @worker_attributes.delete(:email)
  @worker_attributes.delete(:password)
  @worker_attributes.delete(:password_confirmation)
  @attributes_without_email_or_password = @worker_attributes
  

  # validates presence of attributes
  @attributes_without_email_or_password.each do |attribute|
    it { should validate_presence_of attribute }
  end

  it { should be_valid }
end
