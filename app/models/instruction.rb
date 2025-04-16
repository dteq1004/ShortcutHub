class Instruction < ApplicationRecord
  validates :step_number, presence: :true
  validates :content, presence: :true

  belongs_to :shortcut
end
