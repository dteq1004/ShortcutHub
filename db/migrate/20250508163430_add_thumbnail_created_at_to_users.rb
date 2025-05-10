class AddThumbnailCreatedAtToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :thumbnail_created_at, :datetime
  end
end
