class CreateFavorites < ActiveRecord::Migration[7.2]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :shortcut, null: false, foreign_key: true, type: :string

      t.timestamps
    end
    add_index :favorites, [ :user_id, :shortcut_id ], unique: true
  end
end
