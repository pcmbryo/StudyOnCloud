class Reservation < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates :room_id, uniqueness: { scope: :user_id }
end
