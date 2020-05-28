class Room < ApplicationRecord
  belongs_to :user
  has_many :reservations
  has_many :chats

  def myrooms_past object
    room_past = object.where(room_start_datetime: Time.zone.now..Float::INFINITY)
    room_past
  end
end
