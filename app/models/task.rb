class Task < ApplicationRecord
  validates :name, presence: true, length: {maximum: 30}
  validate :validate_name_not_including_comma

  belongs_to :user

  def format_time
    self.created_at.strftime('%Y/%m/%d %H:%M')
  end

  def self.csv_attributes
    ["name", "description", "created_at", "updated_at"]
  end

  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_attributes
      all.each do |task|
        csv << csv_attributes.map{ |attr| task.send(attr)}
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      task = new
      task.attributes = row.to_hash.slice(*csv_attributes)
      task.save!
    end
  end

  private
  def validate_name_not_including_comma
    errors.add(:name, 'cannot include comma in name') if name&.include?(',')
  end

end
