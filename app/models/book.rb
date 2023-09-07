class Book < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :title, presence: true
  validates :body, length: { minimum: 1, maximum: 200 }

#引数で渡されたユーザidがFavoritesテーブル内に存在（exists?）するかどうかを調べ存在していればtrue
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

# 検索方法分岐(解説はuser.rb)
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end

#投稿数の前日比・前週比を表示（モデル側であらかじめ特定の条件式に対して名前をつけて定義し、その名前でメソッドの様に条件式を呼び出す）
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) } #Time.zone.now.all_day = 1日
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) } #昨日
  scope :created_2day_ago, -> { where(created_at: 2.day.ago.all_day) } # 2日前
  scope :created_3day_ago, -> { where(created_at: 3.day.ago.all_day) } # 3日前
  scope :created_4day_ago, -> { where(created_at: 4.day.ago.all_day) } # 4日前
  scope :created_5day_ago, -> { where(created_at: 5.day.ago.all_day) } # 5日前
  scope :created_6day_ago, -> { where(created_at: 6.day.ago.all_day) } # 6日前
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) } #今週
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) } #先週

end
