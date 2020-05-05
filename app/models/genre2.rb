class Genre2 < ApplicationRecord
  belongs_to :genre1
  has_many :rooms
end
