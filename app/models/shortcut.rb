class Shortcut < ApplicationRecord
  before_create :set_id

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 65_535 }, on: :update
  validates :download_url, presence: true, length: { maximum: 65_535 }, on: :update

  belongs_to :user

  private

  def set_id
    while self.id.blank? || Shortcut.find_by(id: self.id).present? do
      self.id = SecureRandom.urlsafe_base64(10)
    end
  end
end
