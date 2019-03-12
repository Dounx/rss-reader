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
    fetch_status = Feed.fetch(feed_params[:link])
    feed = Feed.find_by_link(feed_params[:link])
    feed.subscribe(current_user.id)

    if fetch_status == Feed::FetchStatus[:Success]
      redirect_to user_url(current_user), notice: fetch_status
    elsif fetch_status == Feed::FetchStatus[:NotFound]
      redirect_to user_url(current_user), alert: fetch_status
    elsif fetch_status == Feed::FetchStatus[:HTTPError]
      redirect_to user_url(current_user), alert: fetch_status
    elsif fetch_status == Feed::FetchStatus[:ENOENT]
      redirect_to user_url(current_user), alert: fetch_status
    elsif fetch_status == Feed::FetchStatus[:SocketError]
      redirect_to user_url(current_user), alert: fetch_status
    elsif fetch_status == Feed::FetchStatus[:NotWellFormedError]
      redirect_to user_url(current_user), alert: fetch_status
    elsif fetch_status == Feed::FetchStatus[:TooMuchTagError]
      redirect_to user_url(current_user), alert: fetch_status
    elsif fetch_status == Feed::FetchStatus[:NotAvailableValueError]
      redirect_to user_url(current_user), alert: fetch_status
    elsif fetch_status == Feed::FetchStatus[:MissingTagError]
      redirect_to user_url(current_user), alert: fetch_status
    elsif fetch_status == Feed::FetchStatus[:FeedExistedError]
      redirect_to user_url(current_user), alert: fetch_status
    end
  end

  # DELETE /feeds/1
  def destroy
    @feed.unsubscribe(current_user.id)
    redirect_to user_url(current_user), notice: 'Feed was successfully destroyed'
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
