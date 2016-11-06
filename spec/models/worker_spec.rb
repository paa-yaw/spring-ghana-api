require 'rails_helper'

RSpec.describe Worker, type: :model do
  
  before { @worker = FactoryGirl.build :worker }

  subject { @worker }

  @worker_attributes = [:first_name, :last_name, :age, :sex, :phone_number, :location, :experience, :min_wage, :email, :password,
  	:password_confirmation, :status]


  # validates response to attributes 
  @worker_attributes.each do |attribute|
    it { should respond_to attribute }
  end

  it { should validate_uniqueness_of(:email) }
  it { should validate_uniqueness_of :auth_token}
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

 # association specs
  it { should belong_to :request }


  it { should be_valid }

  describe "generate_auth_token!" do 

    it "expect auth_token to be generated" do 
      allow(Devise).to receive(:friendly_token).and_return("randomUNIQUEtoken123")
      @worker.generate_auth_token!    	
      expect(@worker.auth_token).to eq "randomUNIQUEtoken123"
    end

    it "generates a unique auth_token" do 
      existing_worker = FactoryGirl.create :worker, auth_token: "randomUNIQUEtoken123"
      @worker.generate_auth_token!
      expect(@worker.auth_token).not_to eq existing_worker.auth_token
    end
  end

  describe "test before callback" do
  	  before { @worker = FactoryGirl.build :worker }

      it "successfully" do
        expect(@worker).to receive(:generate_auth_token!)
        @worker.save 
      end
  end

  describe "should respond to the method engage" do 
    
    it { should respond_to :engage }
  end
end
