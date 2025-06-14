class AddGenresToPosts < ActiveRecord::Migration[7.1]
  def change

    add_column :posts, :music_genres, :string, array: true, default: []

  end
end
