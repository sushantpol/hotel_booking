class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.string :room_type
      t.integer :user_id
      t.integer :room_id
      t.date :start_date
      t.date :end_date
      t.integer :total_user

      t.timestamps
    end
  end
end
