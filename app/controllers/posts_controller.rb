class PostsController < ApplicationController
  def index
    scope = FindPosts.new.call(params)

    if params[:friends_only] == "true"
      friend_ids = current_user.friends.pluck(:id)
      scope = scope.where(user_id: friend_ids)
    end

    @posts = scope.load_async
    @all_genres = Post.pluck(:music_genres).flatten.uniq.sort
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    track = RSpotify::Track.find(@post.track_id)
    @post.music_genres = track.artists.first.genres
    if @post.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def autocomplete
    results = RSpotify::Track.search(params[:query])
    render json: results.first(8).map { |track|
      {
        id: track.id,
        name: track.name,
        artist: track.artists.first.name,
        cover: track.album.images.first["url"],
      }
    }
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.user == current_user
      @post.destroy
      redirect_to root_path, notice: "Post deleted successfully."
    else
      redirect_to root_path
    end
  end

  private

  def post_params
    params.require(:post).permit(:content, :mood, :cover_url, :track_id)
  end

end
