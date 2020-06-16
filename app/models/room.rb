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
  
  # 開催日が過去の勉強部屋を返すメソッド
  def self.past_rooms
    self.where.not(room_start_datetime: Time.zone.now..Float::INFINITY)
  end

  # 開催日が未来の勉強部屋を返すメソッド
  def self.future_rooms
    self.where(room_start_datetime: Time.zone.now..Float::INFINITY)
  end

  # 開催者が自分の勉強部屋を取得
  def self.host_rooms(user_id)
    self.where(user_id: user_id)
  end

  # 自分の予約している勉強部屋を取得
  def self.guest_rooms(user_id)
    self.where(reservations: {user_id: user_id})
  end

  # 削除されていない勉強部屋を取得
  def self.not_delete_rooms
    self.where(room_delete_flg: 0)
  end

  def self.join_for_index
    self.eager_load(:user).eager_load(:reservations)
  end

  def self.select_for_index
    self.select("
      rooms.user_id AS host_user_id,
      users.user_name AS host_user_name,
      reservations.user_id AS guest_user_id
      ")
  end

  def self.host_plans(user_id)
    self.join_for_index.select_for_index.host_rooms(user_id).future_rooms.not_delete_rooms
  end

  def self.host_histories(user_id)
    self.join_for_index.select_for_index.host_rooms(user_id).past_rooms.not_delete_rooms
  end

  def self.guest_plans(user_id)
    self.join_for_index.select_for_index.guest_rooms(user_id).future_rooms
  end

  def self.guest_histories(user_id)
    self.join_for_index.select_for_index.guest_rooms(user_id).past_rooms.not_delete_rooms
  end

  def self.home_index
    self.join_for_index.select_for_index.future_rooms.not_delete_rooms
  end
  
end
