class CommentsController < ApplicationController
  before_action :set_feedback

  def create
    @comment = @feedback.comments.build(comment_params)
    if @comment.save
      flash[:notice] = "Your comment has been sent."
      redirect_to @feedback
    else
      flash.now[:alert] = "Something went wrong."
      render 'feedbacks/show'
    end
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to @feedback, notice: "Comment deleted"
  end

  private

    def comment_params
      params.require(:comment).permit(:content)
    end

    def set_feedback
      @feedback ||= Feedback.find_by_url(params[:feedback_id])
    end
end
