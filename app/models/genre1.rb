class Genre1 < ApplicationRecord
  has_many :genre2s
  has_many :rooms
end
