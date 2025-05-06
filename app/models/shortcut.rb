class Shortcut < ApplicationRecord
  before_create :set_id

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 100 }, on: :update
  validates :download_url, presence: true, length: { maximum: 65_535 }, on: :update

  has_many :instructions, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :favorites, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :comments, dependent: :destroy

  belongs_to :user

  enum status: { draft: 0, published: 1, archived: 2 }

  def tag_names
    # NOTE: pluckだと新規作成失敗時に値が残らない(返り値がnilになる)
    # map{|tag| tag.name}
    tags.map(&:name).join(",")
  end

  def self.ransackable_attributes(auth_object = nil)
    ["title", "description"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["taggings", "tags"]
  end

  private

  def set_id
    while self.id.blank? || Shortcut.find_by(id: self.id).present? do
      self.id = SecureRandom.urlsafe_base64(10)
    end
  end
end
