class FindPosts

  attr_reader :posts

  def initialize(posts = initial_scope)
    @posts = posts
  end

  def call(params = {})
    scoped = posts
    scoped = filter_by_mood(scoped, params[:mood])
    scoped = filter_by_music_genres(scoped, params[:music_genres])
    sort(scoped, params[:order_by])
  end

  private

  def initial_scope
    Post.order(id: :desc)
  end

  def filter_by_mood(scoped, mood)
    return scoped unless mood
    scoped.where(mood: mood)
  end

  def filter_by_music_genres(scoped, music_genres)
    return scoped unless music_genres
     scoped.where("? = ANY(music_genres)", music_genres)
  end

  def sort(scoped, order_by)
    order_by_query = Post::ORDER_BY.fetch(order_by&.to_sym, Post::ORDER_BY[:newest])
    if order_by == :popular
      scoped = scoped.left_joins(:reactions).group(:id)  #left_jooins pour assiocer chaque post a ses reaction meme si un post n'en a pas, et group pour regrouper les résultats par post
    end
    scoped.order(order_by_query)
  end

end
