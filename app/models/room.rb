class Room < ActiveRecord::Base

  TYPE = ["Deluxe Rooms", "Luxury Rooms", "Luxury suites", "Presidential Suites"]

  has_many :bookings

  def self.check_rooms(start_date, end_date, room_type)
    if Booking.booked_ids(start_date, end_date)
      self.where("room_type = ? AND id NOT IN (?)", room_type, Booking.booked_ids(start_date, end_date))
    else
      self.where("room_type = ?", room_type)
    end
  end

  def self.populate_db
    Room::TYPE.each_with_index do |main_type, i|
      if i == 0
        ('A'..'D').to_a.each do |a|
          (1..5).each do |s|
            room_no = "#{a}#{s}"       
            self.create(:room_type => main_type, :room_no => room_no, :price => 7000)
          end
        end
      elsif i == 1
        ('A'..'D').to_a.each do |a|
          (6..10).each do |s|
            room_no = "#{a}#{s}"       
            self.create(:room_type => main_type, :room_no => room_no, :price => 8500)
          end
        end
      elsif i == 2
        (11..20).each do |s|
          room_no = "D#{s}"       
          self.create(:room_type => main_type, :room_no => room_no, :price => 12000)
        end
        self.create(:room_type => main_type, :room_no => 'E1')
        self.create(:room_type => main_type, :room_no => 'E2')
      elsif i == 3
        (3..10).each do |s|
          room_no = "E#{s}"       
          self.create(:room_type => main_type, :room_no => room_no, :price => 20000)
        end
      end
    end    
  end

end
