class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :update, :destroy]

  # GET /feeds
  def index
    @feeds = current_user.feeds.order(modified_at: :desc).page params[:page]
  end

  # GET /feeds/1
  def show
    @items = @feed.items.order(created_at: :desc).page params[:page]
  end

  # GET /feeds/new
  def new
    @feed = Feed.new
  end

  # POST /feeds
  def create
    @feed = Feed.fetch(feed_params[:link])
    unless @feed.nil?
      if @feed == 'Same title'
        redirect_to user_url(current_user), alert: 'Please add a different feed.'
      elsif @feed == 'Should subscribe'
        @feed = Feed.find_by(link, feed_params[:link])
        @feed.subscribe(current_user.id)
      else
        subscription = @feed.subscribe(current_user.id)
        respond_to do |format|
          unless subscription.nil?
            format.html { redirect_to user_url(current_user), notice: 'The feed will update after a few minutes.' }
          else
            format.html { redirect_to user_url(current_user), alert: 'Please add a different feed.'  }
          end
        end
      end
    else
      redirect_to user_url(current_user), alert: 'Please add a correct url.'
    end
  end

  # DELETE /feeds/1
  def destroy
    @feed.unsubscribe(current_user.id)
    respond_to do |format|
      format.html { redirect_to user_url(current_user), notice: 'Feed was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feed
      @feed = Feed.find(params[:id])
    end

    def feed_params
      params.require(:feed).permit(:link)
    end
end
