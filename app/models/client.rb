class Client < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  has_many :requests, dependent: :destroy 
  
  before_create :generate_auth_token! 

  validates :first_name, :last_name, :location, :auth_token, presence: true
  validates :auth_token, uniqueness: true

  def generate_auth_token!
  	begin
      self.auth_token = Devise.friendly_token
  	end while self.class.exists?(auth_token: auth_token)
  end
end
