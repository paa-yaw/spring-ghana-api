FactoryGirl.define do
  factory :request do
  	bedrooms { rand(1..100) }
  	bathrooms { rand(1..100) }
  	living_rooms { rand(1..100) }
  	kitchens { rand(1..100) }
  	time_of_arrival { Time.now }
  	schedule { "3 times a week, mondays, wednesdays and fridays" }
  	client   

  	factory :request_with_workers do 
        transient do 
          workers_count 5
        end 
        after(:create) do |request, evaluator|
          create_list(:worker, evaluator.workers_count, requests: [request])
        end 
    end
  end

  factory :worker do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    email { FFaker::Internet.email }
    password "123456789"
    password_confirmation "123456789"
    age { rand(1..45) }
    sex "female"
    phone_number "0203034589"
    location { "Accra, East Legon" }
    experience { FFaker::Lorem.sentence }
    min_wage 100.00

    factory :worker_with_requests do 
      transient do 
      	requests_count 5
      end

      after(:create) do |worker, evaluator|
      	create_list(:request, evaluator.requests_count, workers: [worker])
      end
    end
  end
end
