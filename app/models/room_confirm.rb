class RoomConfirm
  include ActiveModel::Model

  attr_accessor :room_name, :room_detail,
    :room_start_date, :room_start_time,
    :room_end_date, :room_end_time,
    :room_capacity, :user_id

  validates :room_name, presence: true
  validates :room_start_date, presence: true
  validates :room_start_time, presence: true
  validates :room_end_date, presence: true
  validates :room_end_time, presence: true
  validates :room_capacity, presence: true
  validates :user_id, presence: true
end