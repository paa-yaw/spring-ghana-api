class Client < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  has_many :requests, dependent: :destroy 
  
  before_create :generate_auth_token! 

  validates :first_name, :last_name, :location, presence: true
  validates :auth_token, uniqueness: true

  def generate_auth_token!
  	begin
      self.auth_token = Devise.friendly_token
  	end while self.class.exists?(auth_token: auth_token)
  end




  scope :filter_by_first_name, lambda { |name|
    where("lower(first_name) LIKE ?", "#{name.downcase}")
  }


  scope :filter_by_last_name, lambda { |name|
    where("lower(last_name) LIKE ?", "#{name.downcase}")
  }

  scope :filter_by_location, lambda { |location|
    where("lower(location) LIKE ?", "#{location.downcase}")
  }




  def self.search(params = {})

    clients = Client.where(admin: false)

    clients = clients.filter_by_first_name(params[:first_name]) if params[:first_name]
    clients = clients.filter_by_last_name(params[:last_name]) if params[:last_name]
    clients = clients.filter_by_location(params[:location]) if params[:location]


    clients
  end
  
end
