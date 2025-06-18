class RoomsController < ApplicationController
  before_action :authenticate_user!
  def index
    @room = Room.new
    @rooms = Room.public_rooms
    @user = current_user
    @users = @user.friends

    @notifications = current_user.notifications.where(type: "MessageNotification")
    @notifications.mark_as_read!
  end

  def show
    @single_room = Room.find(params[:id])
    @room = Room.new
    @rooms = Room.public_rooms

    @users = User.all_except(current_user)

    @message = Message.new
    @messages = @single_room.messages.order(created_at: :asc)
  end

  def create
    @room = Room.create(room_params)
  end

  private

  def room_params
     params.require(:room).permit(:name)
  end

end
