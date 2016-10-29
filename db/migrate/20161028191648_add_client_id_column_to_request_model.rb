class AddClientIdColumnToRequestModel < ActiveRecord::Migration
  def change
  	add_column :requests, :client_id, :integer
  	add_index :requests, :client_id
  end
end
