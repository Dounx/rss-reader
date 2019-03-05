class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :edit, :update, :destroy]

  # GET /feeds
  def index
    @feeds = current_user.feeds.order(modified_at: :desc).page params[:page]
    # InitFeedsWorker.perform_async(@feeds.map(&:link))
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
    @feed = Feed.find_or_create_by(link: feed_params[:link])
    subscription = Subscription.find_by(user_id: current_user.id, feed_id: @feed.id)

    respond_to do |format|
      if subscription.nil?
        Subscription.create(user_id: current_user.id, feed_id: @feed.id)
        RefreshFeedsWorker.perform_async(@feed.link)
        format.html { redirect_to feeds_url, notice: 'The feed will update after a few minutes.' }
      else
        format.html { render :new }
      end
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
    subscription = Subscription.find_by(user_id: current_user.id, feed_id: params[:id])
    subscription.destroy

    respond_to do |format|
      format.html { redirect_to feeds_url, notice: 'Feed was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feed
      @feed = Feed.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feed_params
      params.require(:feed).permit(:title, :link, :description, :language)
    end
end
