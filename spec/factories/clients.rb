FactoryGirl.define do
  factory :client do
  	email { FFaker::Internet.email }
  	password "123456789"
  	password_confirmation "123456789"
  	first_name { FFaker::Name.first_name }
  	last_name { FFaker::Name.last_name }
  	location { "Accra, East Legon" }
    auth_token { Devise.friendly_token }

    trait :admin do 
      admin true
    end
  end
end
