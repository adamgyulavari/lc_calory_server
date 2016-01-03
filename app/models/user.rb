class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable

  has_many :entries

  def to_json
    { email: email, id: id, entry_count: entries.count, goal: goal }.to_json
  end
end
