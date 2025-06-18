class MessagesController < ApplicationController
  def create
    @single_room = Room.find(params[:room_id])
    @message = current_user.messages.new(body: msg_params[:body], room_id: params[:room_id])
      if @message.save
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to room_path(@message.room) }
        end
      else
        redirect_to room_path(@message.room), status: :unprocessable_entity
      end
  end

  private

  def msg_params
    params.require(:message).permit(:body)
  end
end
