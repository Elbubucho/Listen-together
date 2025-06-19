class FindPosts

  attr_reader :posts

  def initialize(posts = initial_scope)
    @posts = posts
  end

  def call(params = {}, current_user = nil)
    scoped = posts
    scoped = filter_by_mood(scoped, params[:mood])
    scoped = filter_by_friends_only(scoped, current_user, params[:friends_only])
    scoped = filter_by_music_genres(scoped, params[:music_genres])
    scoped
  end

  private

  def initial_scope
    Post.order(id: :desc).limit(10)
  end

  def filter_by_mood(scoped, mood)
    return scoped unless mood
    scoped.where(mood: mood)
  end

  def filter_by_friends_only(scoped, current_user, friends_only)
    return scoped unless friends_only == "true"
    return scoped unless current_user

    friend_ids = current_user.friends.pluck(:id)
    scoped.where(user_id: friend_ids)
  end

  def filter_by_music_genres(scoped, music_genres)
    return scoped unless music_genres
     scoped.where("? = ANY(music_genres)", music_genres)
  end

end
