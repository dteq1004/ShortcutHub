class RemoveThumbnailCreatedAtFromUsers < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :thumbnail_created_at, :datetime
  end
end
