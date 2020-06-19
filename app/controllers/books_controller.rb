class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit]      #URL直打ち防止

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
    @user = @book.user
    @newbook = Book.new
  end

  def index
    @user = current_user
    @books = Book.all #一覧表示するためにBookモデルの情報を全てくださいのall
    @book = Book.new #new bookの新規投稿で必要（保存処理はbookコントローラー側で実施）
  end

  def create
    @book = Book.new(book_params) #Bookモデルのテーブルを使用しているのでbookコントローラで保存する。
    @book.user_id = current_user.id

    if @book.save #入力されたデータをdbに保存する。
      redirect_to @book, notice: "successfully created book!"#保存された場合の移動先を指定。
    else
      @books = Book.all
      flash[:alert1] = @book.errors.full_messages
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end



  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to @book, notice: "successfully updated book!"
    else #if文でエラー発生時と正常時のリンク先を枝分かれにしている。
      flash[:alert1] = @book.errors.full_messages
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path, notice: "successfully delete book!"
  end



    def correct_user
        books = Book.find(params[:id])
        if current_user != books.user
            @micropost = current_user.books.find_by(id: params[:id])
            unless @micropost
                redirect_to books_path
            end
        end
    end


  private
    def book_params
      params.require(:book).permit(:title, :body)
    end

end
