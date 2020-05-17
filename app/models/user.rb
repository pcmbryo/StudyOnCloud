class User < ApplicationRecord
  #アイコン画像アップロードのために追加
  mount_uploader :image, ImageUploader

  before_save { self.email = email.downcase }
  has_many :rooms
  has_many :reservations
  has_many :chats

  has_many :active_relationships,
            class_name:  "Relationship",   
           foreign_key: "follower_id",
             dependent:   :destroy
  has_many :following, 
    through: :active_relationships,
     source: :followed

  has_many :passive_relationships,
            class_name: "Relationship",
            foreign_key: "followed_id",
            dependent:  :destroy
  has_many :followers,
    through: :positive_relationships,
     source:  :follower
  
  validates :user_name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: {minimum: 8}

    # ユーザーをフォローする
    def follow(other_user)
      following << other_user
    end
  
    # ユーザーをフォロー解除する
    def unfollow(other_user)
      active_relationships.find_by(followed_id: other_user.id).destroy
    end
  
    # 現在のユーザーがフォローしてたらtrueを返す
    def following?(other_user)
      following.include?(other_user)
    end
end
