class Book < ApplicationRecord
	belongs_to :user
    has_many :book_comments, dependent: :destroy
	has_many :favorites, dependent: :destroy
	#バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
	#presence trueは空欄の場合を意味する。
	validates :title, {presence: true}
	validates :body, {presence: true, length: {maximum: 200}}

	def favorited_by?(user)
        favorites.where(user_id: user.id).exists?
    end

  def self.search(search, select, how_search)
      if select == "2"
        if how_search == "1"
          Book.where(['title LIKE ?', "%#{search}"])   #完全一致検索
        elsif how_search == "2"
          Book.where(['title LIKE ?', "#{search}%"])  #前方一致検索
        elsif how_search == "3"
          Book.where(['title LIKE ?', "#{search}"])  #後方一致検索
        elsif how_search == "4"
          Book.where(['title LIKE ?', "%#{search}%"])  #部分一致検索
        end
        
      else
        Book.all
      end
    end

end
