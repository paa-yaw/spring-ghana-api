FactoryGirl.define do
  factory :request do
  	bedrooms { rand(1..100) }
  	bathrooms { rand(1..100) }
  	living_rooms { rand(1..100) }
  	kitchens { rand(1..100) }
  	time_of_arrival { Time.now }
  	schedule { "3 times a week, mondays, wednesdays and fridays" }    
  end
end
