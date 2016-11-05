class AddAuthTokenToWorkerModel < ActiveRecord::Migration
  def change
  	add_column :workers, :auth_token, :string, unique: true
  end
end
