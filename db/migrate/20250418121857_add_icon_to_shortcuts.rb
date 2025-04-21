class AddIconToShortcuts < ActiveRecord::Migration[7.2]
  def change
    add_column :shortcuts, :icon, :string, default: "icon1"
  end
end
