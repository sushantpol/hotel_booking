class AddPriceAndFinalPriceToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :price, :float
    add_column :bookings, :final_price, :float
  end
end
