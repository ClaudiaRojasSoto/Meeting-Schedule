require 'rails_helper'

RSpec.describe ScheduleItem, type: :model do
  describe 'associations' do
    it { should belong_to(:meeting) }
  end

  describe 'validations' do
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:duration_minutes) }
    it { should validate_presence_of(:role) }
    it { should validate_numericality_of(:duration_minutes).is_greater_than(0) }
  end

  describe '#duration_display' do
    it 'returns formatted duration' do
      item = build(:schedule_item, duration_minutes: 15)
      expect(item.duration_display).to eq("15 min")
    end
  end
end
