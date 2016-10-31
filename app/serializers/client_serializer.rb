class ClientSerializer < ActiveModel::Serializer
  attributes :id, :email, :location, :first_name, :last_name, :auth_token, :admin, :created_at, :updated_at
end
