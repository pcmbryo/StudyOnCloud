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
  
  #開催日が過去の勉強部屋を返すメソッド
  def self.find_past_room
    self.where.not(room_start_datetime: Time.zone.now..Float::INFINITY)
  end

  #開催日が未来の勉強部屋を返すメソッド
  def self.find_future_room
    self.where(room_start_datetime: Time.zone.now..Float::INFINITY)
  end

  #
  def self.get_room_host_id
    self.user_id
  end

end
