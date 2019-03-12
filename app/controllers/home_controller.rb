class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    @feeds = Array.new
    9.times do
      @feeds << Feed.find(Feed.ids.shuffle.first)
    end
  end
end
