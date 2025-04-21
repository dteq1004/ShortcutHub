class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :shortcut

  validates :tag_id, uniqueness: { scope: :shortcut_id }
end
