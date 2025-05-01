class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :shortcut

  validates :user_id, uniqueness: { scope: :shortcut_id }
end
