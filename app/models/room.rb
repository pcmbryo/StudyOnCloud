class Room < ApplicationRecord
  belongs_to :user
  belongs_to :genre1
  belongs_to :genre2
  has_many :reservations
  has_many :chats
end
