class RecommendedFeedsController < ApplicationController

  # GET /recommended_feeds
  def index
    @recommended_feeds = RecommendedFeed.all.page params[:page]
  end

  # POST /recommended_feeds
  def create
    feed = Feed.find_or_create_by(link: params[:link])
    subscription = Subscription.new(user_id: current_user.id, feed_id: feed.id)
    AddFeedWorker.perform_async(feed.link)
    respond_to do |format|
      if subscription.save
        format.html { redirect_to recommended_feeds_url, notice: 'Recommended feed was successfully subscribed.' }
      else
        format.html { redirect_to recommended_feeds_url, alert: 'Recommended feed was not subscribed.' }
      end
    end
  end


  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def subscription_params
      params.permit(:user_id, :link)
    end
end
