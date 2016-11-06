class AddRequestIdToWorker < ActiveRecord::Migration
  def change
  	add_reference :workers, :request, index: true, foreign_key: true
  end
end
