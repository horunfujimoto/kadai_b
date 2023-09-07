class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    #投稿数の前日比・前週比を表示
    @today_book =  @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
  end

  def index
    @users = User.all
    @book = Book.new
    @user = current_user
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  def search
    @user = User.find(params[:user_id])
    @books = @user.books
    @book = Book.new
    if params[:created_at] == "" #入力欄が空欄なら、「日付を選択してください」と表示
      @search_book = "日付を選択してください"
    else
      create_at = params[:created_at] #入力された日付を「create_at」に代入
      @search_book = @books.where(['created_at LIKE ? ', "#{create_at}%"]).count
      #@userの持つ全Bookデータのうち、created_at が 入力された create_at と同じ年月日のものを取得し、数を数え、@search_book に代入
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
