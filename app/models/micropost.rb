class Micropost < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy

  mount_uploader :picture, PictureUploader
  default_scope -> { order(created_at: :desc) } #デフォルtの取り出しを照準に
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size

  def like_user(user)
    likes.find_by(user_id: user.id).nil?
  end


  private

  # アップロードされた画像のサイズをバリデーションする
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end


end
