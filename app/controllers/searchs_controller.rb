class SearchsController < ApplicationController

  def search
    @select = params[:option]
    @how_search = params[:choice]

    if @select == "1"
      @users = User.search(params[:search], @select, @how_search)
    else
      @books = Book.search(params[:search], @select, @how_search)
    end
  end

end
