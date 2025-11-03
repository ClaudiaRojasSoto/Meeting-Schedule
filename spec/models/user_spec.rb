require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_inclusion_of(:role).in_array(User::ROLES) }
  end

  describe '#admin?' do
    it 'returns true when user is admin' do
      user = create(:user, role: 'admin')
      expect(user.admin?).to be true
    end

    it 'returns false when user is member' do
      user = create(:user, role: 'member')
      expect(user.admin?).to be false
    end
  end

  describe '#member?' do
    it 'returns true when user is member' do
      user = create(:user, role: 'member')
      expect(user.member?).to be true
    end

    it 'returns false when user is admin' do
      user = create(:user, role: 'admin')
      expect(user.member?).to be false
    end
  end
end
