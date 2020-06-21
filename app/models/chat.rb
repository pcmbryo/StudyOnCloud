class Chat < ApplicationRecord
  belongs_to :room
  belongs_to :user
  validates  :text, presence: true
  validates  :user_id, presence: true
  validates  :room_id, presence: true

  # createの後にコミットする { MessageBroadcastJobのperformを遅延実行 引数はself }
  after_create_commit { MessageBroadcastJob.perform_later self }
end
