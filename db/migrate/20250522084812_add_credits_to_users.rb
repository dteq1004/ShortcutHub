class AddCreditsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :credits, :integer, default: 1, null: false
  end
end
