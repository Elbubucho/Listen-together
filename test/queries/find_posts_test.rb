# test/queries/find_posts_test.rb

require 'test_helper'

class FindPostsTest < ActiveSupport::TestCase
  setup do
    # Crée des posts de test
    @happy_post = Post.create!(mood: "happy")
    @sad_post = Post.create!(mood: "sad")
  end

  test "returns all posts if no params" do
    result = FindPosts.new.call
    assert_equal 2, result.count
  end

  test "filters by mood" do
    result = FindPosts.new.call(mood: "happy")
    assert_equal 1, result.count
    assert_equal "happy", result.first.mood
  end

  test "sorts by order_by" do
    # Ici, il faut que Post::ORDER_BY existe, par exemple { newest: "created_at DESC" }
    # Tu peux créer un post plus vieux pour tester
    old_post = Post.create!(mood: "happy", created_at: 1.day.ago)
    result = FindPosts.new.call(order_by: "newest")
    assert_equal @happy_post.id, result.first.id # Le plus récent créé
  end
end
