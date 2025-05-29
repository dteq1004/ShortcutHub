class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :shortcuts, through: :taggings

  validates :name, presence: true, uniqueness: true

  scope :popular, -> { where(id: Tagging.group(:tag_id).order("count_tag_id desc").limit(5).count(:tag_id).keys) }
end
