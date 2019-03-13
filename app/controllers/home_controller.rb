class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    @feeds = Feed.all.limit(9).to_a.shuffle
  end
end
