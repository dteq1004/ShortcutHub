class User < ApplicationRecord
  before_create :set_account_name
  before_create :set_account_uid
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :shortcuts, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy, inverse_of: :follower
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy, inverse_of: :follower
  has_many :followings, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :favorites, dependent: :destroy
  has_many :favorite_shortcuts, through: :favorites, source: :shortcut

  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_shortcuts, through: :bookmarks, source: :shortcut

  has_one_attached :avatar
  validates :avatar, content_type: { in: %w[image/jpeg image/gif image/png], message: "有効なフォーマットではありません" }, size: { less_than: 5.megabytes, message: " 5MBを超える画像はアップロードできません" }

  VALID_UID_REGEX = /\A[a-zA-Z0-9]+\z/
  validates :uid, presence: true, uniqueness: true, length: { minimum:3, maximum: 16 }, format: { with: VALID_UID_REGEX }, on: :update

  validates :name, presence: true, uniqueness: true, length: { minimum:3, maximum: 16 }, on: :update
  validates :email, presence: true, uniqueness: { case_insensitive: true }, format: { with: Devise.email_regexp }

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    followings.include?(other_user)
  end

  def followed?(other_user)
    followers.include?(other_user)
  end

  def favorite(shortcut)
    favorite_shortcuts << shortcut
  end

  def unfavorite(shortcut)
    favorite_shortcuts.destroy(shortcut)
  end

  def favorite?(shortcut)
    favorite_shortcuts.include?(shortcut)
  end

  def bookmark(shortcut)
    bookmark_shortcuts << shortcut
  end

  def unbookmark(shortcut)
    bookmark_shortcuts.destroy(shortcut)
  end

  def bookmark?(shortcut)
    bookmark_shortcuts.include?(shortcut)
  end

  def to_param
    uid
  end

  private

  def set_account_name
    while self.name.blank? || User.find_by(name: self.name).present? do
      self.name = SecureRandom.base36
    end
  end

  def set_account_uid
    while self.uid.blank? || User.find_by(uid: self.uid).present? do
      self.uid = SecureRandom.base36
    end
  end
end
