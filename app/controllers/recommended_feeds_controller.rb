class RecommendedFeedsController < ApplicationController
  before_action :set_recommended_feed, only: [:show, :edit, :update, :destroy]

  # GET /recommended_feeds
  # GET /recommended_feeds.json
  def index
    @recommended_feeds = RecommendedFeed.all
  end

  # GET /recommended_feeds/1
  # GET /recommended_feeds/1.json
  def show
  end

  # GET /recommended_feeds/new
  def new
    @recommended_feed = RecommendedFeed.new
  end

  # GET /recommended_feeds/1/edit
  def edit
  end

  # POST /recommended_feeds
  # POST /recommended_feeds.json
  def create
    @recommended_feed = RecommendedFeed.new(recommended_feed_params)

    respond_to do |format|
      if @recommended_feed.save
        format.html { redirect_to @recommended_feed, notice: 'Recommended feed was successfully created.' }
        format.json { render :show, status: :created, location: @recommended_feed }
      else
        format.html { render :new }
        format.json { render json: @recommended_feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recommended_feeds/1
  # PATCH/PUT /recommended_feeds/1.json
  def update
    respond_to do |format|
      if @recommended_feed.update(recommended_feed_params)
        format.html { redirect_to @recommended_feed, notice: 'Recommended feed was successfully updated.' }
        format.json { render :show, status: :ok, location: @recommended_feed }
      else
        format.html { render :edit }
        format.json { render json: @recommended_feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recommended_feeds/1
  # DELETE /recommended_feeds/1.json
  def destroy
    @recommended_feed.destroy
    respond_to do |format|
      format.html { redirect_to recommended_feeds_url, notice: 'Recommended feed was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recommended_feed
      @recommended_feed = RecommendedFeed.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recommended_feed_params
      params.require(:recommended_feed).permit(:title, :description, :link)
    end
end
