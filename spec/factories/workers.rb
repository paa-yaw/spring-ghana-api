FactoryGirl.define do
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
  end
end
