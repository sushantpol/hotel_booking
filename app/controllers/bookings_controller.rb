class BookingsController < ApplicationController

  before_action :authenticate_user, :only => [:new, :create]

  def index
    @bookings = user_signed_in? ? current_user.bookings.includes(:room) : []
    respond_to do |format|
      format.html
      format.json {render :status => 200, :json => {:bookings => @bookings}}
    end
  end

  
  def new
    @booking = Booking.new(room_type: params[:room_type])
  end

  
  def create
    @booking = current_user.bookings.build(booking_params)
    respond_to do |format|
      if @booking.save
        format.html { redirect_to bookings_path, notice: 'Booking was successfully created.' }
        format.json { render :status => 200, :json => {booking: @booking} }
      else
        format.html { render :new}
        format.json { render :status => 301, json: @booking.errors}
      end
    end
  end

  private

    def booking_params
      params.require(:booking).permit(:room_type, :room_id, :start_date, :end_date, :total_user)
    end

end
