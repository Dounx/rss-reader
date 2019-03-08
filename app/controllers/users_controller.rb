class UsersController < ApplicationController
  before_action :is_current_user

  def show
    @feed = Feed.new
    @feeds = current_user.feeds.order(modified_at: :desc).page params[:page]
  end

  private
    def is_current_user
      unless current_user.id.to_s == params[:id]
        redirect_back(fallback_location: root_path, alert: "You can only visit your own profile page.")
      end
    end
end
