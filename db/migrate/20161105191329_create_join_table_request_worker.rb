class CreateJoinTableRequestWorker < ActiveRecord::Migration
  def change
    create_join_table :requests, :workers do |t|
      t.index [:request_id, :worker_id]
      t.index [:worker_id, :request_id]
    end
  end
end
