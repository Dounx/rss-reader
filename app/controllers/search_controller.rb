class SearchController < ApplicationController
  def index
    @items = current_user.items.where("title LIKE ?", '%' + search_params[:q] + '%').page params[:page]
  end

  private

  def search_params
    params.permit(:q)
  end
end
