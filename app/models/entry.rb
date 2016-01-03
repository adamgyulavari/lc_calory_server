class Entry < ActiveRecord::Base
  belongs_to :user

  scope :latest, -> (limit) { order('created_at DESC').limit(limit) }

  scope :from_date, ->(day) { where('entry_date > ?', day) }
  scope :to_date, ->(day) { where('entry_date <= ?', day) }

  scope :from_time, ->(time) {where('entry_time > ?', time) }
  scope :to_time, ->(time) {where('entry_time <= ?', time) }

end
