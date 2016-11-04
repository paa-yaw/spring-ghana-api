class AddPasswordDigestToWorker < ActiveRecord::Migration
  def change
  	add_column :workers, :password_digest, :string
  end
end
