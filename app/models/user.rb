class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,:validatable

  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy # フォロー取得
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy # フォロワー取得
  has_many :following_user, through: :follower, source: :followed # 自分がフォローしている人
  has_many :follower_user, through: :followed, source: :follower # 自分をフォローしている人

  attachment :profile_image, destroy: false

  #バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
  validates :name, length: {maximum: 20, minimum: 2}

	validates :introduction, length: { maximum: 50 }

    # ユーザーをフォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  # ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  # フォローしていればtrueを返す
  def following?(user)
    following_user.include?(user)
  end

  def self.search(search, select, how_search)
      if select == "1"
        if how_search == "1"
          User.where(['name LIKE ?', "%#{search}"])   #完全一致検索
        elsif how_search == "2"
          User.where(['name LIKE ?', "#{search}%"])  #前方一致検索
        elsif how_search == "3"
          User.where(['name LIKE ?', "#{search}"])  #後方一致検索
        elsif how_search == "4"
          User.where(['name LIKE ?', "%#{search}%"])  #部分一致検索
        end
      else
          User.all
      end
    end

end
