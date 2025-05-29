class CreateTaggings < ActiveRecord::Migration[7.2]
  def change
    create_table :taggings do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :shortcut, null: false, foreign_key: true, type: :string

      t.timestamps
    end
    add_index :taggings, [ :tag_id, :shortcut_id ], unique: true
  end
end
