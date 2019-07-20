class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.float :price
      t.string :room_no
      t.string :room_type

      t.timestamps
    end
  end
end
