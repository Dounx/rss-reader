class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :destroy]

  # GET /items
  def index
    @items = current_user.items.order(created_at: :desc).page params[:page]
    session[:all_items] = false
  end

  # GET /items/1
  def show
    if session[:all_items]
      items = @item.feed.items.order(created_at: :desc)
      @next_item = items[items.index(@item) + 1]
    else
      items = current_user.items.order(created_at: :desc)
      @next_item = items[items.index(@item) + 1]
    end
    @comments = @item.comments.order(created_at: :desc).page params[:page]
    @comment = Comment.new
  end

  # DELETE /items/1
  def destroy
    item_state = ItemState.find_by(user_id: current_user.id, item_id: params[:id])
    item_state.destroy
    redirect_to items_url, notice: 'Item was successfully destroyed'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end
end
