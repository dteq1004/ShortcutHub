class ChangeDefaultCreditsInUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_default :users, :credits, 150
    User.update_all(credits: 150)
  end
end
