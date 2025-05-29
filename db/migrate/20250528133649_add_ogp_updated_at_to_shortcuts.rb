class AddOgpUpdatedAtToShortcuts < ActiveRecord::Migration[7.2]
  def change
    add_column :shortcuts, :ogp_updated_at, :datetime
  end
end
