class CreateFriendships < ActiveRecord::Migration[7.1]
  def change
    create_table :friendships do |t|
      t.references :asker, foreign_key: { to_table: :users }, null: false
      t.references :receiver, foreign_key: { to_table: :users }, null: false
      t.boolean :confirmed, default: false, null: false

      t.timestamps
    end
  end
end
