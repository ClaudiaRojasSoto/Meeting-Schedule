class ScheduleItem < ApplicationRecord
  belongs_to :meeting

  validates :start_time, :duration_minutes, :role, presence: true
  validates :duration_minutes, numericality: { greater_than: 0 }

  def duration_display
    "#{duration_minutes} min"
  end
end
