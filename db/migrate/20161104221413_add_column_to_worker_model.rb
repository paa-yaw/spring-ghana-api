class AddColumnToWorkerModel < ActiveRecord::Migration
  def change
  	add_column :workers, :email, :string, default: "", unique: true
  end
end
