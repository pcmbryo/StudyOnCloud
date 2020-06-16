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

  # 指定したカラムの昇順を返す
  def self.asc(column)
    self.order(column)
  end

  # 指定したカラムの降順を返す
  def self.desc(column)
    self.order(column => "DESC")
  end

  # 開催日が過去の勉強部屋を返す
  def self.past_rooms
    self.where.not(room_end_datetime: Time.zone.now..Float::INFINITY)
  end

  # 開催日が未来の勉強部屋を返す
  def self.future_rooms
    self.where(room_end_datetime: Time.zone.now..Float::INFINITY)
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

  # 一覧表示に必要なテーブルを結合する
  def self.join_for_index
    self.joins(:user).includes(:reservations).references(:reservations)
  end

  # 一覧表示に必要なカラムをセレクトする
  def self.select_for_index
    self.select("
      rooms.id,
      rooms.room_name,
      rooms.room_detail,
      rooms.room_start_datetime,
      rooms.room_end_datetime,
      rooms.room_capacity,
      rooms.room_delete_flg,
      rooms.user_id AS host_user_id,
      users.user_name AS host_user_name,
      reservations.user_id AS guest_user_id
      ")
  end

  # 開催予定
  def self.host_plans(user_id)
    self.join_for_index.select_for_index.host_rooms(user_id).future_rooms.not_delete_rooms
  end

  # 開催履歴
  def self.host_histories(user_id)
    self.join_for_index.select_for_index.host_rooms(user_id).past_rooms.not_delete_rooms.asc(:room_start_datetime)
  end

  # 参加予定
  def self.guest_plans(user_id)
    self.join_for_index.select_for_index.guest_rooms(user_id).future_rooms.asc(:room_start_datetime)
  end

  # 参加履歴
  def self.guest_histories(user_id)
    self.join_for_index.select_for_index.guest_rooms(user_id).past_rooms.not_delete_rooms.asc(:room_start_datetime)
  end

  # 予約できる勉強会一覧
  def self.home_index
    self.join_for_index.select_for_index.future_rooms.not_delete_rooms.asc(:room_start_datetime)
  end


  # def self.merge_tables2
  #   self.joins(:user).joins("LEFT OUTER JOIN 
  #     reservations ON rooms.id = reservations.room_id").select("rooms.id,rooms.room_name,rooms.room_detail,
  #     rooms.room_start_datetime,rooms.room_end_datetime,rooms.room_capacity,rooms.room_delete_flg,
  #     rooms.user_id,users.user_name AS host_user_name,reservations.user_id AS guest_user_id")
  # end
end
