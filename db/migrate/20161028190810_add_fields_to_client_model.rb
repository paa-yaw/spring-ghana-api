class AddFieldsToClientModel < ActiveRecord::Migration
  def change
  	add_column :clients, :first_name, :string, default: ""
  	add_column :clients, :last_name, :string, default: ""
  	add_column :clients, :location, :text
  	add_column :clients, :auth_token, :string, default: "", unique: true
  	add_column :clients, :admin, :boolean, default: false
  end
end
