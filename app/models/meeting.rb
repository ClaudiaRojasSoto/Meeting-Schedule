class Meeting < ApplicationRecord
  has_many :schedule_items, -> { order(:position) }, dependent: :destroy

  validates :title, :date, presence: true

  scope :upcoming, -> { where("date >= ?", Date.today).order(:date) }
  scope :past, -> { where("date < ?", Date.today).order(date: :desc) }
end
