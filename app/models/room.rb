class Room < ApplicationRecord
  belongs_to :user
  has_many :reservations, dependent: :destroy
  has_many :chats, dependent: :destroy

  validates :room_name, presence: true
  validates :room_start_datetime, presence: true
  validates :room_end_datetime, presence: true
  validates :room_capacity, presence: true
  validates :user_id, presence: true

  # 指定したカラムの昇順を返す
  def self.asc(column)
    self.order(column)
  end

  # 指定したカラムの降順を返す
  def self.desc(column)
    self.order(column => "DESC")
  end

  # 開催日時が未来の勉強会を返す
  def self.future_rooms
    self.where(room_start_datetime: Time.zone.now..Float::INFINITY)
  end

  # 進行中の勉強会
  def self.in_session_room
    self.where(room_end_datetime: Time.zone.now..Float::INFINITY).where.not(room_start_datetime: Time.zone.now..Float::INFINITY)
  end

  # 終了日時が過去の勉強会を返す
  def self.past_rooms
    self.where.not(room_end_datetime: Time.zone.now..Float::INFINITY)
  end

  # 開催者が自分の勉強会を取得
  def self.host_rooms(user_id)
    self.where(user_id: user_id)
  end

  # 自分の予約している勉強会を取得
  def self.guest_rooms(user_id)
    self.where(reservations: {user_id: user_id})
  end

  # 削除されていない勉強会を取得
  def self.not_delete_rooms
    self.where(room_delete_flg: 0)
  end

  # 一覧表示に必要なテーブルを結合する
  def self.join_user
    self.eager_load(:user).eager_load(:reservations).select("
      rooms.user_id AS host_user_id,
      users.user_name AS host_user_name")
  end

  # 一覧表示に必要なカラムをセレクトする
  def self.join_user_reservation
    self.eager_load(:user).eager_load(:reservations).select("
      rooms.user_id AS host_user_id,
      users.user_name AS host_user_name,
      reservations.user_id AS guest_user_id")
  end

  # 予約できる勉強会一覧
  def self.home_index
    self.join_user.future_rooms.not_delete_rooms.asc(:room_start_datetime)
  end

  # 開催予定
  def self.host_plans(user_id)
    self.join_user.host_rooms(user_id).future_rooms.not_delete_rooms
  end

  # 開催履歴
  def self.host_histories(user_id)
    self.join_user.host_rooms(user_id).past_rooms.not_delete_rooms.asc(:room_start_datetime)
  end
  
  # 進行中（開催）
  def self.host_now(user_id)
    self.join_user.host_rooms(user_id).in_session_room.not_delete_rooms
  end

  # 参加予定
  def self.guest_plans(user_id)
    self.join_user_reservation.guest_rooms(user_id).future_rooms.asc(:room_start_datetime)
  end

  # 参加履歴
  def self.guest_histories(user_id)
    self.join_user_reservation.guest_rooms(user_id).past_rooms.not_delete_rooms.asc(:room_start_datetime)
  end

  # 進行中（参加）
  def self.guest_now(user_id)
    self.join_user_reservation.guest_rooms(user_id).in_session_room
  end
end
