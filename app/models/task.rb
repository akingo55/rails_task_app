class Task < ApplicationRecord
  validates :name, presence: true, length: {maximum: 30}
  validate :validate_name_not_including_comma

  belongs_to :user

  def format_time
    self.created_at.strftime('%Y/%m/%d %H:%M')
  end

  private
  def validate_name_not_including_comma
    errors.add(:name, 'cannot include comma in name') if name&.include?(',')
  end

end
