class WorkerSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :age, :sex, :phone_number, :location, :experience, :min_wage, :email, :auth_token, 
  :status
end
