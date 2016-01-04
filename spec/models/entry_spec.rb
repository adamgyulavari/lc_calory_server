require 'rails_helper'

RSpec.describe Entry, type: :model do
  it 'has a valid factory' do
    expect(create :entry).to be_valid
  end

  describe 'invalid' do
    it 'when no title present' do
      expect(build :entry, title: nil).to be_invalid
    end

    it 'when no num present' do
      expect(build :entry, num: nil).to be_invalid
    end

    it 'when no entry_date present' do
      expect(build :entry, entry_date: nil).to be_invalid
    end

    it 'when no entry_time present' do
      expect(build :entry, entry_time: nil).to be_invalid
    end
  end

  describe 'scoped' do
    before :each do
      user = create :user
      @entry_in1, @entry_in2 = create(:entry, user_id: user.id, entry_date: 3.days.ago, entry_time: 7200),
                               create(:entry, user_id: user.id, entry_date: 4.days.ago, entry_time: 8000)
      @entry_o1, @entry_o2 = create(:entry, user_id: user.id, entry_date: 1.days.ago, entry_time: 7200),
                             create(:entry, user_id: user.id, entry_date: 2.days.ago, entry_time: 9600)
    end
    it 'returns entries within specified date and time' do
      expect(Entry.from_date(5.days.ago).to_date(2.days.ago).from_time(7000).to_time(8600))
        .to match_array([@entry_in1, @entry_in2])
    end
    it 'does not return entries without specified date and time' do
      expect(Entry.from_date(5.days.ago).to_date(2.days.ago).from_time(7000).to_time(8600))
        .not_to include [@entry_o1, @entry_o2]
    end
  end
end
