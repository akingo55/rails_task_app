class Task < ApplicationRecord
  validates :name, presence: true, length: {maximum: 30}
  validate :validate_name_not_including_comma

  private
  def validate_name_not_including_comma
    errors.add(:name, 'cannot include comma in name') if name&.include?(',')
  end
end
