class ReactionsController < ApplicationController
  before_action :authentificate_user!
  before_action :set_post

  def create
    @reaction = @post.reactions.build(user: current_user)

    if @reaction.save
      redirect_to posts_path, notice: 'Post liké avec succès'
    else
      redirect_to posts_path, alert: 'Vous avez déjà liké ce post'
    end
  end

  def destroy
    @reaction = @post.reactions.find_by(user: current_user)
    @reaction&.destroy
    redirect_to posts_path, notice: 'Like retiré'
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
