class CreateComments < ActiveRecord::Migration[7.2]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :shortcut, null: false, foreign_key: true, type: :string
      t.text :body
      t.integer :parent_id

      t.timestamps
    end
    add_index :comments, :parent_id
  end
end
