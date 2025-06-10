class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :content
      t.string :mood
      t.string :cover_url
      t.string :track_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
