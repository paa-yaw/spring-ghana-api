class Worker < ActiveRecord::Base
  
  validates :first_name, :last_name, :age, :sex, :phone_number, :location, :experience, :min_wage, presence: true
  validates_format_of :email,:with => Devise::email_regexp, allow_blank: true
  validates :email, uniqueness: true
end
