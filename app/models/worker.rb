class Worker < ActiveRecord::Base

  has_secure_password
  
  validates :first_name, :last_name, :age, :sex, :phone_number, :location, :experience, :min_wage, :password_confirmation, presence: true
  validates_format_of :email,:with => Devise::email_regexp, allow_blank: true
  validates :email, :auth_token, uniqueness: true
  validates :phone_number, length: { is: 10 }
  validates :age, numericality: { only_integer: true }



  before_create :generate_auth_token!

  def generate_auth_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end
end
