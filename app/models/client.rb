class Client < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  has_many :requests, dependent: :destroy 

  validates :first_name, :last_name, :location, :auth_token, presence: true
  validates :auth_token, uniqueness: true
end
