class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    @recommended_feeds = RecommendedFeed.all.page params[:page]
  end
end
