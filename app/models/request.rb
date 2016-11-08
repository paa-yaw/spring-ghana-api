class Request < ActiveRecord::Base

  belongs_to :client, inverse_of: :requests
  has_many :workers

   
  validates :bedrooms, :bathrooms, :living_rooms, :kitchens, :time_of_arrival, :schedule, :client_id, :status, presence: true
  validates :bedrooms, :bathrooms, :living_rooms, :kitchens, numericality: { greater_than_or_equal_to: 0 }
  


  def resolve
    self.update(status: "RESOLVED")
  end

  def request_completed?
    self.update(status: "COMPLETED") if self.workers.empty?
  end





  scope :filter_by_bedroom_number, lambda { |number| 
    where("bedrooms == ?", number)
  }

  scope :min_bedrooms, lambda { |number|
  	where("bedrooms >= ?", number)
  }

  scope :max_bedrooms, lambda { |number|
    where("bedrooms <= ?", number)
  }




   scope :filter_by_bathroom_number, lambda { |number| 
     where("bathrooms == ?", number)
   }

  scope :min_bathrooms, lambda { |number|
  	where("bathrooms >= ?", number)
   }

  scope :max_bathrooms, lambda { |number|
    where("bathrooms <= ?", number)
  }








   scope :filter_by_kitchen_number, lambda {  |number|
     where("kitchens == ?", number)
   }

   scope :min_kitchens, lambda { |number|
  	where("kitchens >= ?", number)
   }

   scope :max_kitchens, lambda { |number|
    where("kitchens <= ?", number)
   }









   scope :filter_by_living_room_number, lambda {  |number|
     where("living_rooms == ?", number)
   }

   scope :min_living_rooms, lambda { |number|
  	where("living_rooms >= ?", number)
   }

   scope :max_living_rooms, lambda { |number|
    where("living_rooms <= ?", number)
   }






   scope :recent, -> { 
     order(:time_of_arrival)
   }






   def self.search(params = {})
     requests = Request.all 

     requests = requests.filter_by_bedroom_number(params[:bedrooms]) if params[:bedrooms]
     requests = requests.min_bedrooms(params[:min_bedroom_number].to_i) if params[:min_bedroom_number]
     requests = requests.max_bedrooms(params[:max_bedroom_number].to_i) if params[:max_bedroom_number]

     requests = requests.filter_by_bathroom_number(params[:bathrooms]) if params[:bathrooms]
     requests = requests.min_bedrooms(params[:min_bathroom_number].to_i) if params[:min_bathroom_number]
     requests = requests.max_bedrooms(params[:max_bathroom_number].to_i) if params[:max_bathroom_number]

     requests = requests.filter_by_kitchen_number(params[:kitchens]) if params[:kitchens]
     requests = requests.min_kitchens(params[:min_kitchen_number].to_i) if params[:min_kitchen_number]
     requests = requests.max_kitchens(params[:max_kitchen_number].to_i) if params[:max_kitchen_number]


     requests = requests.filter_by_living_room_number(params[:living_rooms]) if params[:living_rooms]
     requests = requests.min_living_rooms(params[:min_living_rooms].to_i) if params[:min_living_rooms]
     requests = requests.max_living_rooms(params[:max_living_rooms].to_i) if params[:max_living_rooms]

     requests = requests.recent(params[:recent]) if params[:recent]
     
     requests	
   end  
end
