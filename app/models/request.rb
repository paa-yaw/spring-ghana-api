class Request < ActiveRecord::Base

  belongs_to :client
   
  validates :bedrooms, :bathrooms, :living_rooms, :kitchens, :time_of_arrival, :schedule, :client_id, presence: true
  validates :bedrooms, :bathrooms, :living_rooms, :kitchens, numericality: { greater_than_or_equal_to: 0 }
end
