class Room < ApplicationRecord
  belongs_to :user
  belongs_to :genre1
  belongs_to :genre2
  has_many :reservations
  has_many :chats

  # 現在時刻より未来に開催される勉強会を取得する
  def find_by_future
    rooms = Room.where(room_start_datetime: Time.zone.now..Float::INFINITY)
    rooms
  end

  # 現在時刻より過去に開催された勉強会を取得する
  def find_by_past
    rooms = Room.where.not(room_start_datetime: Time.zone.now..Float::INFINITY)
    rooms
  end
end
