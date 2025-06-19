class UsersController < ApplicationController
    include RoomsHelper
  before_action :authenticate_user!, :set_user, only: [:show, :chat, :friends]

  def index
    if params[:query].present?
      @users = User.where("username ILIKE ?", "%#{params[:query]}%")
    else
      @users = User.none
    end
  end

  def autocomplete
    users = User.where("username ILIKE ?", "%#{params[:query]}%").limit(5)
    render json: users.map { |u| { id: u.id, name: u.username } }
  end

  def edit_profile
    @user = current_user
  end

  def update_profile
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "Profil updated successfully !"
    else
      flash[:alert] = @user.errors.full_messages.join(', ')
      redirect_to user_edit_profile_path(@user)
    end
  end

  def friends
    if @user != current_user
      redirect_to root_path, alert: "Access denied."
      return
    end

    @friends = @user.friends
  end

  def friend_requests_sent
    render json: current_user.pending_friend_requests_sent
  end

  def friend_requests_received
    render json: current_user.pending_friend_requests_received
  end

  def show
    @friends = @user.friends
    @friends_count = @friends.count
    @posts = @user.posts.order(created_at: :desc)

    @friend_requests_sent = current_user.pending_friend_requests_sent
    @friend_requests_received = current_user.pending_friend_requests_received

    @is_own_profile = (@user == current_user)

    @existing_friendship = Friendship.find_by(asker: current_user, receiver: @user) ||
                           Friendship.find_by(asker: @user, receiver: current_user)

  end

  def chat
    @users = @user.friends

    @room = Room.new
    @rooms = Room.where(is_private: false)
    @room_name = get_name(@user, current_user)
    @single_room = Room.where(name: @room_name).first || Room.create_private_room([@user, current_user], @room_name)

    @message = Message.new
    @messages = @single_room.messages.order(created_at: :asc)

    @notifications = current_user.notifications
    .where(type: "MessageNotification")
    .where("params ->> 'room_id' = ?", @single_room.id.to_s)
    .unread

    @notifications.mark_as_read!
    render "rooms/show"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :avatar_url, :bio)
  end
end
