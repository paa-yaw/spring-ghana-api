class AddStatusToWorkerModel < ActiveRecord::Migration
  def change
  	add_column :workers, :status, :string, default: "unassigned"
  end
end
