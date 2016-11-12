FactoryGirl.define do

  factory :worker do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    email { FFaker::Internet.email }
    password "123456789"
    password_confirmation "123456789"
    age { rand(1..45) }
    sex { ["male", "female"][rand(0..1)] }
    phone_number "0203034589"
    location { "Accra, East Legon" }
    experience { FFaker::Lorem.sentence }
    min_wage { rand(1..100).to_f }
    status { ["UNASSIGNED", "ASSIGNED"][rand(0..1)] }
    request
  end



  factory :request do
    bedrooms { rand(1..100) }
    bathrooms { rand(1..100) }
    living_rooms { rand(1..100) }
    kitchens { rand(1..100) }
    time_of_arrival { Time.now }
    schedule { "3 times a week, mondays, wednesdays and fridays" }
    status "UNRESOLVED"
    client   

  factory :request_with_workers do 
    transient do 
      workers_count 5
    end

    after(:create) do |request, evaluator|
      create_list(:worker, evaluator.workers_count, request: request)
    end 

   end
  end
end
