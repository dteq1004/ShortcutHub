class CreateShortcuts < ActiveRecord::Migration[7.2]
  def change
    create_table :shortcuts, id: :string do |t|
      t.string :title, null: false
      t.text :description, null: false, default: ""
      t.text :download_url, null: false, default: ""
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
