class Worker < ActiveRecord::Base

  has_secure_password

  belongs_to :request, inverse_of: :workers

  
  validates :first_name, :last_name, :age, :sex, :phone_number, :location, :experience, :min_wage, :status, presence: true
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

  def engage
    self.update(status: "ASSIGNED")
  end

  def disengage
    self.update(status: "UNASSIGNED")
  end




  scope :filter_by_first_name, lambda { |name| 
    where("lower(first_name) LIKE ?", "#{name.downcase}")
   }

   scope :filter_by_last_name, lambda { |name| 
    where("lower(last_name) LIKE ?", "#{name.downcase}")
   }



   scope :filter_by_min_age, lambda { |age|
    where("age >= ?", age)
   }

   scope :filter_by_max_age, lambda { |age| 
    where("age <= ?", age)
   }



   scope :filter_by_sex, lambda { |sex|
    where("sex LIKE ?", "#{sex.downcase}")
   }



   scope :filter_by_status, lambda { |status| 
    where("status LIKE ?", "#{status.upcase}")
   }




   scope :minimum_wage, lambda { |min_wage|
    where("min_wage == ?", min_wage)
   }

   scope :lower_min_wage, lambda { |min_wage|
    where("min_wage <= ?", min_wage)
   }

   scope :higher_min_wage, lambda { |min_wage| 
    where("min_wage >= ?", min_wage)
   }




   def self.search(params={})
     workers = Worker.all

     workers = workers.filter_by_first_name(params[:first_name]) if params[:first_name]
     workers = workers.filter_by_last_name(params[:last_name]) if params[:last_name]


     workers = workers.filter_by_min_age(params[:min_age].to_i) if params[:min_age]
     workers = workers.filter_by_max_age(params[:max_age].to_i) if params[:max_age]

     workers = workers.filter_by_sex(params[:sex]) if params[:sex]

     workers = workers.filter_by_status(params[:status]) if params[:status]
     
     workers = workers.minimum_wage(params[:min_wage]) if params[:min_wage]
     workers = workers.lower_min_wage(params[:lower_min_wage]) if params[:lower_min_wage]
     workers = workers.higher_min_wage(params[:higher_min_wage]) if params[:higher_min_wage]

     workers
   end
end
