class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :destroy]

  # GET /comments/1
  def show
  end

  # POST /comments
  def create
    @comment = current_user.comments.new(comment_params)
    @comment.user_id = params[:user_id]
    @comment.item_id = params[:item_id]

    respond_to do |format|
      if @comment.save
        format.html { redirect_to url_for(@comment.item) + '#footer', notice: 'Comment was successfully created.' }
      else
        format.html { redirect_to url_for(@comment.item) + '#footer', alert: 'Please input some words.' }
      end
    end
  end

  # DELETE /comments/1
  def destroy
    item = @comment.item
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to url_for(item_url(item)) + '#footer', notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:content)
    end
end
