class CreateInstructions < ActiveRecord::Migration[7.2]
  def change
    create_table :instructions do |t|
      t.references :shortcut, null: false, foreign_key: true, type: :string
      t.integer :step_number
      t.text :content

      t.timestamps
    end
  end
end
