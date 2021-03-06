class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :update, :destroy]

  # GET /feeds
  def index
    @feeds = current_user.feeds.order(modified_at: :desc).page params[:page]
  end

  # GET /feeds/1
  def show
    @items = @feed.items.order(created_at: :desc).page params[:page]
    session[:all_items] = true
  end

  # GET /feeds/new
  def new
    @feed = Feed.new
  end

  # POST /feeds
  def create
    fetch_status = FetchFeedsWorker.new.perform(feed_params[:link])

    last_url = request.referrer
    if fetch_status == Feed::FetchStatus[:Success] || fetch_status == Feed::FetchStatus[:FeedExistedError]
      feed = Feed.find_by_link(feed_params[:link])
      feed.subscribe(current_user.id)
      redirect_to last_url, notice: fetch_status
    elsif fetch_status == Feed::FetchStatus[:NotFound]
      redirect_to last_url, alert: fetch_status
    elsif fetch_status == Feed::FetchStatus[:HTTPError]
      redirect_to last_url, alert: fetch_status
    elsif fetch_status == Feed::FetchStatus[:ENOENT]
      redirect_to last_url, alert: fetch_status
    elsif fetch_status == Feed::FetchStatus[:SocketError]
      redirect_to last_url, alert: fetch_status
    elsif fetch_status == Feed::FetchStatus[:NotWellFormedError]
      redirect_to last_url, alert: fetch_status
    elsif fetch_status == Feed::FetchStatus[:TooMuchTagError]
      redirect_to last_url, alert: fetch_status
    elsif fetch_status == Feed::FetchStatus[:NotAvailableValueError]
      redirect_to last_url, alert: fetch_status
    elsif fetch_status == Feed::FetchStatus[:MissingTagError]
      redirect_to last_url, alert: fetch_status
    elsif fetch_status == Feed::FetchStatus[:ECONNRESET]
      redirect_to last_url, alert: fetch_status
    elsif fetch_status == Feed::FetchStatus[:ETIMEDOUT]
      redirect_to last_url, alert: fetch_status
    elsif fetch_status == Feed::FetchStatus[:OpenTimeout]
      redirect_to last_url, alert: fetch_status
    elsif fetch_status == Feed::FetchStatus[:ECONNREFUSED]
      redirect_to last_url, alert: fetch_status
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
