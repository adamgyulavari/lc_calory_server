require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(create :user).to be_valid
  end

  describe 'invalid' do
    it 'when no email present' do
      expect(build :user, email: nil).to be_invalid
    end

    it 'when no password present' do
      expect(build :user, password: nil).to be_invalid
    end
  end
end
