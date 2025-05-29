class Instruction < ApplicationRecord
  before_validation :sanitize_instruction, on: :update

  validates :step_number, presence: true
  validates :content, presence: true

  belongs_to :shortcut

  private

  def sanitize_instruction
    self.instruction = ActionController::Base.helpers.sanitize(instruction, tags: [], attributes: [])
  end
end
