class RequestSerializer < ActiveModel::Serializer
  attributes :id, :bedrooms, :bathrooms, :bathrooms, :kitchens, :living_rooms, :time_of_arrival, :schedule, :created_at,
   :updated_at, :status

  has_one :client 
  has_many :workers, embed: :ids
end
