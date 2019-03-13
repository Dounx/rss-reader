class RecommendedFeedsController < ApplicationController

  # GET /recommended_feeds
  def index
    @feeds = RecommendedFeed.all.page params[:page]
  end

  # POST /recommended_feeds
  def create
    if Feed.fetch(params[:link]) == Feed::FetchStatus[:Success]
      feed = Feed.find_by_link(params[:link])
      feed.subscribe(current_user.id)
      redirect_to recommended_feeds_url, notice: 'Recommended feed was successfully subscribed'
    else
      redirect_to recommended_feeds_url, alert: 'This recommended feed has been broken'
    end

  end


  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def subscription_params
      params.permit(:user_id, :link)
    end
end
