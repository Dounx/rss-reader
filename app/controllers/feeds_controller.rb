class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :edit, :update, :destroy]

  # GET /feeds
  def index
    @feed = Feed.new
    @feeds = current_user.feeds.order(modified_at: :desc).page params[:page]
  end

  # GET /feeds/1
  def show
    @items = Feed.find(params[:id]).items.order(created_at: :desc).page params[:page]
  end

  # GET /feeds/new
  def new
    @feed = Feed.new
  end

  # GET /feeds/1/edit
  def edit

  end

  # POST /feeds
  def create
    @feed = Feed.find_by(link: feed_params[:link]) || Feed.new(link: feed_params[:link])
    if @feed.save
      subscription = Subscription.find_by(user_id: current_user.id, feed_id: @feed.id)
      respond_to do |format|
        if subscription.nil?
          Subscription.create(user_id: current_user.id, feed_id: @feed.id)
          AddFeedWorker.perform_async(@feed.link)
          format.html { redirect_to feeds_url, notice: 'The feed will update after a few minutes.' }
        else
          format.html { redirect_to feeds_url, alert: 'Please add a different feed.'  }
        end
      end
    else
      redirect_to feeds_url, alert: 'Please add a correct url.'
    end
  end

  # PATCH/PUT /feeds/1
  def update
    respond_to do |format|
      if @feed.update(feed_params)
        format.html { redirect_to @feed, notice: 'Feed was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /feeds/1
  def destroy
    Subscription.find_by(feed_id: @feed.id)&.destroy
    respond_to do |format|
      format.html { redirect_to feeds_url, notice: 'Feed was successfully destroyed.' }
    end
    CleanFeedsWorker.perform_async
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feed
      @feed = Feed.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feed_params
      params.require(:feed).permit(:link)
    end
end
