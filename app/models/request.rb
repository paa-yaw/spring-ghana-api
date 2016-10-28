class Request < ActiveRecord::Base
  
  validates :bedrooms, :bathrooms, :living_rooms, :kitchens, :time_of_arrival, :schedule, presence: true
  validates :bedrooms, :bathrooms, :living_rooms, :kitchens, numericality: { greater_than_or_equal_to: 0 }
end
