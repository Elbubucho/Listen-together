class MessagesController < ApplicationController

  def create
    @message = current_user.messages.new(body: msg_params[:body], room_id: params[:room_id])

    if @message.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to room_path(@message.room), notice: "Message sent." }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("new_message_form", partial: "messages/new_message_form", locals: { message: @message })
        end
        format.html { redirect_to room_path(params[:room_id]), status: :unprocessable_entity }
      end
    end
  end


  private

  def msg_params
    params.require(:message).permit(:body)
  end
end
