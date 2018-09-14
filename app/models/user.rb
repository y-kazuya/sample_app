class User < ApplicationRecord
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  before_save { email.downcase! } #保存じにemailを小文字に!で値自体を更新   self.は省略してる
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }




end