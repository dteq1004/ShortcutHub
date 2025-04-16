class AddStatusToShortcuts < ActiveRecord::Migration[7.2]
  def change
    add_column :shortcuts, :status, :integer, default: 0
  end
end
