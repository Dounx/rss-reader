class ItemsController < ApplicationController
  before_action :set_item, only: [:show]

  # GET /items
  def index
    @items = current_user.items.order(created_at: :desc).page params[:page]
  end

  # GET /items/1
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # DELETE /items/1
  def destroy
    item_state = ItemState.find_by(user_id: current_user.id, item_id: params[:id])
    item_state.destroy

    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end
end
