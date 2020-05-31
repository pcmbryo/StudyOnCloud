class Room < ApplicationRecord
  belongs_to :user
  has_many :reservations
  has_many :chats

  validates :room_name, presence: true
  validates :room_detail, presence: true
  validates :room_start_datetime, presence: true
  validates :room_end_datetime, presence: true
  validates :room_capacity, presence: true
  validates :user_id, presence: true
end
