class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
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
    RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])
    results = RSpotify::Track.search(params[:query])
    render json: results.first(8).map { |track|
      {
        id: track.id,
        name: track.name,
        artist: track.artists.first.name,
        cover: track.album.images.first["url"]
      }
    }
  end

  private

  def post_params
    params.require(:post).permit(:content, :mood, :cover_url, :track_id)
  end

end
