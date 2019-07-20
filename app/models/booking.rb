class Booking < ActiveRecord::Base

  belongs_to :room
  belongs_to :user

  after_validation :available_rooms

  validate :start_date_and_end_date_validation
  validates :user_id, :start_date, :end_date, presence: true


  def start_date_and_end_date_validation 
    if Date.today > start_date.to_date
      errors.add(:start_date, "check in date should be greater or equal to today's date")
    elsif Date.today + 6.months < end_date.to_date 
      errors.add(:end_date, "Check out date should be smaller than 6 months")
    elsif end_date.to_date < start_date.to_date
      errors.add(:end_date, "check out date should be greater than Check in Date")
    end
  end

  def self.booked_ids(start_date, end_date)
    rootm_ids = Booking.where("Date(start_date) < ? AND Date(end_date) > ? ", end_date, start_date).pluck(:room_id)
    if rootm_ids.empty?
      return false
    else
      return rootm_ids
    end
  end

  def available_rooms
    a = Room.check_rooms(start_date, end_date, room_type).limit(1).first rescue nil
    if a.present?
      self.room_id = a.id
      self.price = a.price
      self.final_price = a.price * self.total_user
    else
      errors.add(:total_user, "Room(s) not available for #{room_type}")
    end
  end

end
