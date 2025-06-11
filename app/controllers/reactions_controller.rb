class ReactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @reaction = @post.reactions.build(user: current_user)
    @reaction.save
    render turbo_stream: turbo_stream.replace(
      "reaction_button_#{@post.id}",
      partial: "reactions/button",
      locals: { post: @post }
    )
  end

  def destroy
    @reaction = @post.reactions.find_by(user: current_user)
    @reaction&.destroy
    render turbo_stream: turbo_stream.replace(
      "reaction_button_#{@post.id}",
      partial: "reactions/button",
      locals: { post: @post }
    )
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
