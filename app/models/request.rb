class Request < ActiveRecord::Base

  belongs_to :client
   
  validates :bedrooms, :bathrooms, :living_rooms, :kitchens, :time_of_arrival, :schedule, :client_id, presence: true
  validates :bedrooms, :bathrooms, :living_rooms, :kitchens, numericality: { greater_than_or_equal_to: 0 }

  scope :filter_by_bedroom_number, lambda { |number| 
    where("bedrooms == ?", number)
  }

   scope :filter_by_bathroom_number, lambda { |number| 
     where("bathrooms == ?", number)
   }

   scope :filter_by_kitchen_number, lambda {  |number|
     where("kitchens == ?", number)
   }

   scope :filter_by_living_room_number, lambda {  |number|
     where("living_rooms == ?", number)
   }

   scope :recent, lambda { |arrival|
     where("time_of_arrival == ?", arrival) }
end
