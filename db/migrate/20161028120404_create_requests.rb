class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer  :bedrooms, default: 0
      t.integer  :bathrooms, default: 0
      t.integer  :living_rooms, defautl: 0
      t.integer  :kitchens, default: 0
      t.datetime :time_of_arrival
      t.text     :schedule

      t.timestamps null: false
    end
  end
end
