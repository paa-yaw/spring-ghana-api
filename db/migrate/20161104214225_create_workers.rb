class CreateWorkers < ActiveRecord::Migration
  def change
    create_table :workers do |t|
      t.string :first_name, default: ""
      t.string :last_name, default: ""
      t.integer :age, default: 0
      t.string :sex, default: ""
      t.string :phone_number, default: ""
      t.text :location, default: ""
      t.text :experience, default: ""
      t.decimal :min_wage, default: 0.0

      t.timestamps null: false
    end
  end
end
