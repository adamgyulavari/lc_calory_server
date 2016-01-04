class Entry < ActiveRecord::Base
  belongs_to :user

  scope :latest, -> (limit) { order('created_at DESC').limit(limit) }

  scope :from_date, ->(day) { where('entry_date > ?', day) }
  scope :to_date, ->(day) { where('entry_date < ?', day) }

  scope :from_time, ->(time) {where('entry_time > ?', time) }
  scope :to_time, ->(time) {where('entry_time < ?', time) }

  validates :title, presence: true
  validates :num, presence: true
  validates :num, numericality: { greater_than_or_equal_to: 0 }
  validates :entry_date, presence: true
  validates :entry_time, presence: true

end
