class FriendshipsController < ApplicationController
  def create
    receiver = User.find(params[:receiver_id])

    if receiver == current_user
      render json: { error: "You cannot send a friend request to yourself." }, status: :unprocessable_entity
      return
    end

    existing = Friendship.find_by(asker: current_user, receiver: receiver) ||
              Friendship.find_by(asker: receiver, receiver: current_user)

    if existing
      render json: { error: "Friendship or request already exists." }, status: :unprocessable_entity
      return
    end

    @friendship = Friendship.create(asker: current_user, receiver: receiver)

    if @friendship.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to user_path(receiver), notice: "Friend request sent." }
      end
    else
      render json: { errors: @friendship.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @friendship = Friendship.find(params[:id])

    if @friendship.receiver == current_user && !@friendship.confirmed?
      @friendship.update(confirmed: true)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to user_path(@friendship.asker), notice: "Friend request accepted." }
      end
    else
      render json: { error: "Not authorized or already accepted." }, status: :unauthorized
    end
  end

  def destroy
    @friendship = Friendship.find(params[:id])

    if @friendship.asker == current_user || @friendship.receiver == current_user
      message =
        if @friendship.confirmed?
          "Friendship removed."
        elsif @friendship.asker == current_user
          "Friend request cancelled."
        else
          "Friend request declined."
        end

      @friendship.destroy
      render json: { message: message }
    else
      render json: { error: "Unauthorized action." }, status: :unauthorized
    end
  end
end
