class Shortcut < ApplicationRecord
  before_create :set_id

  validates :title, presence: true, length: { minimum: 3, maximum: 50 }
  validates :description, presence: true, length: { minimum: 3, maximum: 100 }, on: :update, if: :published?
  validates :download_url, presence: true, format: {
    with: /\Ahttps:\/\/www\.icloud\.com\/shortcuts\/[a-zA-Z0-9]+\z/,
    message: "は有効はiCloudショートカットのURLを指定してください"
  }, on: :update, if: :published?

  has_many :instructions, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :favorites, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  belongs_to :user

  has_one_attached :thumbnail

  enum status: { draft: 0, published: 1, archived: 2 }

  def create_notification_favorite!(current_user)
    temp = Notification.where(visitor_id: current_user.id, visited_id: user_id, shortcut_id: id, action: "favorite")
    return if temp.present?

    notification = current_user.active_notifications.new(shortcut_id: id, visited_id: user_id, action: "favorite")
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end

  def create_notification_bookmark!(current_user)
    temp = Notification.where(visitor_id: current_user.id, visited_id: user_id, shortcut_id: id, action: "bookmark")
    return if temp.present?

    notification = current_user.active_notifications.new(shortcut_id: id, visited_id: user_id, action: "bookmark")
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end

  def create_notification_comment!(current_user, comment_id)
    notification = current_user.active_notifications.new(visitor_id: current_user.id, visited_id: user_id, shortcut_id: id, comment_id: comment_id, action: "comment")
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end

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
