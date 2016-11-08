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
    it { should respond_to :disengage }
  end

  # scopes

  describe "#.filter_by_first_name" do 
    before do 
      @worker1 = FactoryGirl.create :worker, first_name: "Yaw"
      @worker2 = FactoryGirl.create :worker, first_name: "Grace"
      @worker3 = FactoryGirl.create :worker, first_name: "Akua"
    end

    it "should return worker with first name 'Akua'" do 
      expect(Worker.filter_by_first_name('Akua').sort).to match_array([@worker3])
    end
  end

  describe "#.filter_by_last_name" do 
    before do 
      @worker1 = FactoryGirl.create :worker, last_name: "Boakye"
      @worker2 = FactoryGirl.create :worker, last_name: "Ampofo"
      @worker3 = FactoryGirl.create :worker, last_name: "Ansah"
    end

    it "should return with last name 'Ansah'" do 
      expect(Worker.filter_by_last_name('Ansah').sort).to match_array([@worker3])
    end
  end



  describe "#.filter by age" do 

     before do 
       @worker1 = FactoryGirl.create :worker, age: 23
       @worker2 = FactoryGirl.create :worker, age: 43
       @worker3 = FactoryGirl.create :worker, age: 50
       @worker4 = FactoryGirl.create :worker, age: 30
       @worker5 = FactoryGirl.create :worker, age: 28
       @worker6 = FactoryGirl.create :worker, age: 47
     end

     context "#.filter_by_min_age" do 
       it "should return worker with 30 as min age" do 
         expect(Worker.filter_by_min_age(30).sort).to match_array([@worker4, @worker2, @worker6, @worker3])
       end
     end

     context "#.filter_by_max_age" do 
       it "should return worker with 30 as max age" do 
         expect(Worker.filter_by_max_age(30).sort).to match_array([@worker1, @worker5, @worker4])
       end
     end
  end 



  describe "#.filter_by_sex" do 
    before do 
      @worker1 = FactoryGirl.create :worker, sex: "male"
      @worker2 = FactoryGirl.create :worker, sex: "female"
    end

    it "should return male worker" do 
      expect(Worker.filter_by_sex("male").sort).to match_array([@worker1])
    end

    it "should return female worker" do 
      expect(Worker.filter_by_sex("female").sort).to match_array([@worker2])
    end
  end   


  describe "#.filter_by_status" do 
    before do 
      @worker1 = FactoryGirl.create :worker, status: "UNASSIGNED"
      @worker2 = FactoryGirl.create :worker, status: "ASSIGNED"
    end

    it "should return 'UNASSIGNED' worker" do 
      expect(Worker.filter_by_status("UNASSIGNED").sort).to match_array([@worker1])
    end

    it "should return 'ASSIGNED' worker" do 
      expect(Worker.filter_by_status("ASSIGNED").sort).to match_array([@worker2])
    end
  end



  describe "#.filter by level of minimum wage" do
    before do 
      @worker1 = FactoryGirl.create :worker, min_wage: 100.00
      @worker2 = FactoryGirl.create :worker, min_wage: 300.00
      @worker3 = FactoryGirl.create :worker, min_wage: 350.00
      @worker4 = FactoryGirl.create :worker, min_wage: 250.00
      @worker5 = FactoryGirl.create :worker, min_wage: 150.00
    end

    context "minimum wage" do
      it "should return workers with exact minimum wage" do 
        expect(Worker.minimum_wage(100.00).sort).to match_array([@worker1])
      end
    end

    context "lower range of minimum wage" do
      it "should return workers of min_wage equal to or below 300.00" do 
        expect(Worker.lower_min_wage(300.00).sort).to match_array([@worker1, @worker5, @worker4, @worker2])
      end
    end

    context "higher range of minimum wage" do 
      it "should return workers of minimum wage equal to or above 300.00" do 
        expect(Worker.higher_min_wage(300.00).sort).to match_array([@worker2, @worker3])
      end
    end
  end



  # search engine

  describe ".search" do 
    before do 
      @worker1 = FactoryGirl.create :worker, first_name: "Dave", last_name: "Doson", age: 44, sex: "male", 
      min_wage: 100.00, status: "UNASSIGNED"

      @worker2 = FactoryGirl.create :worker, first_name: "Mary", last_name: "Anderson", age: 22, sex: "female", 
      min_wage: 120.00, status: "UNASSIGNED" 

      @worker3 = FactoryGirl.create :worker, first_name: "Clifford", last_name: "Johnson", age: 33, sex: "male",
       min_wage: 200.00, status:  "ASSIGNED"
    end

    context "when no params supplied" do 
      it "should return all workers" do 
        expect(Worker.search({})).to match_array([@worker1, @worker2, @worker3])
      end
    end

    context "when first name is Dave" do 
      it "should return worker1" do 
        params = { first_name: "Dave"}
        expect(Worker.search(params)).to match_array([@worker1])
      end
    end

    context "when last name is Ruth" do 
      it "should return an empty array" do 
        params = { last_name: "Ruth" }
        expect(Worker.search(params)).to be_empty
      end
    end

    context "when min age is 20 and max age is 35" do
      it "should return worker 2 and 3" do 
        params = { min_age: 20, max_age: 35 }
        expect(Worker.search(params)).to match_array([@worker2, @worker3])
      end
    end

    context "when sex is female" do 
      it "should return worker 2" do 
        params = { sex: "female" }
        expect(Worker.search(params)).to match_array([@worker2])
      end
    end

    context "when male and minimum wage is 100.00 and UNASSIGNED" do 
      it "should return worker1" do 
        params = { sex: "male", min_wage: 100.00, status: "UNASSIGNED" }
        expect(Worker.search(params)).to match_array([@worker1])
      end
    end
  end
end
