class AddViewCountToShortcuts < ActiveRecord::Migration[7.2]
  def change
    add_column :shortcuts, :view_count, :integer, default: 0
  end
end
