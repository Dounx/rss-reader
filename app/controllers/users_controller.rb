class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  before_action :is_current_user

  def show
    @feed = Feed.new
    @feeds = current_user.feeds.order(modified_at: :desc).page params[:page]
  end

  def edit
  end

  def update
    @user.password = comment_params[:password]
    @user.password_confirmation = comment_params[:password_confirmation]

    if @user.save
      bypass_sign_in(@user)
      redirect_to edit_user_url(@user), notice: "Update user info successful"
    else
      redirect_to edit_user_url(@user), alert: "Update user info failed"
    end

  end

  private
    def is_current_user
      unless current_user.id.to_s == params[:id]
        redirect_back(fallback_location: root_path, alert: "You can only visit your own profile page.")
      end
    end

    def set_user
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
