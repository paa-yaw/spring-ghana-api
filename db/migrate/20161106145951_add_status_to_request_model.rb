class AddStatusToRequestModel < ActiveRecord::Migration
  def change
  	add_column :requests, :status, :string, default: "unresolved"
  end
end
