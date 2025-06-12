class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to @user, notice: "Profil mis à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def friends
    user = User.find(params[:id])
    if user != current_user
      render json: { error: "Access denied." }, status: :unauthorized
      return
    end
    render json: user.friends
  end

  def friend_requests_sent
    render json: current_user.pending_friend_requests_sent
  end

  def friend_requests_received
    render json: current_user.pending_friend_requests_received
  end

  def show
    @user = User.find(params[:id])
    @friends = @user.friends
    @friends_count = @friends.count
    @posts = @user.posts.order(created_at: :desc)

    @friend_requests_sent = current_user.pending_friend_requests_sent
    @friend_requests_received = current_user.pending_friend_requests_received

    @is_own_profile = (@user == current_user)

    @existing_friendship = Friendship.find_by(asker: current_user, receiver: @user) ||
                           Friendship.find_by(asker: @user, receiver: current_user)
  end

  private

  def user_params
    params.require(:user).permit(:username, :avatar_url, :bio)
  end
end
