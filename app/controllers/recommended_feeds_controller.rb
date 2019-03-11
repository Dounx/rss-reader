class RecommendedFeedsController < ApplicationController

  # GET /recommended_feeds
  def index
    @recommended_feeds = RecommendedFeed.all.page params[:page]
  end

  # POST /recommended_feeds
  def create
    feed = Feed.find_by(link: params[:link]) || Feed.fetch(params[:link])
    if feed
      feed.subscribe(current_user.id)
      respond_to do |format|
        format.html { redirect_to recommended_feeds_url, notice: 'Recommended feed was successfully subscribed.' }
      end
    else
      respond_to do |format|
        format.html { redirect_to recommended_feeds_url, alert: 'This recommended feed has been broken.' }
      end
    end

  end


  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def subscription_params
      params.permit(:user_id, :link)
    end
end
