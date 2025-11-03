require 'rails_helper'

RSpec.describe Meeting, type: :model do
  describe 'associations' do
    it { should have_many(:schedule_items).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:date) }
  end

  describe 'scopes' do
    let!(:past_meeting) { create(:meeting, date: 1.week.ago) }
    let!(:upcoming_meeting) { create(:meeting, date: 1.week.from_now) }

    describe '.upcoming' do
      it 'returns future meetings' do
        expect(Meeting.upcoming).to include(upcoming_meeting)
        expect(Meeting.upcoming).not_to include(past_meeting)
      end
    end

    describe '.past' do
      it 'returns past meetings' do
        expect(Meeting.past).to include(past_meeting)
        expect(Meeting.past).not_to include(upcoming_meeting)
      end
    end
  end
end
