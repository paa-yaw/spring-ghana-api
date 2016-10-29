require 'rails_helper'

RSpec.describe Client, type: :model do
  before { @client = FactoryGirl.create :client }

  subject { @client }

  @client_attributes = [ :email, :password, :password_confirmation, :first_name, :last_name, :location, :auth_token, :admin]

  # response specs of attributes

  @client_attributes.each do |attribute|
    it { should respond_to attribute }
  end

  # validation specs

  @validated_attributes = [ :email, :first_name, :last_name, :location, :auth_token]

  @validated_attributes.each do |attribute|
    it { should validate_presence_of attribute }
  end

  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_uniqueness_of :auth_token }
  it { should validate_confirmation_of :password  }
end
