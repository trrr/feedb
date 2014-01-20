class FeedbacksController < ApplicationController
  before_filter :authenticate_user!, except: :show

  def show
    @feedback = Feedback.find_by_url(params[:id])
    @comment = @feedback.comments.build
    @comments = @feedback.comments.reject(&:new_record?)
    respond_to do |format|
      format.html
      format.json do 
        render json: {feedback: @feedback, comments: @comments}
      end
    end
  end

  def index
    @feedbacks = current_user.feedbacks.reject(&:new_record?)
    @feedback = current_user.feedbacks.build
  end

  def create
    @feedback = current_user.feedbacks.build(feedback_params)
    if @feedback.save
     flash[:notice] = "New feedback has been successfully created."
     redirect_to @feedback
    else
      flash[:alert] = "Something went wrong. Try again."
      render 'new'
    end
  end

  def destroy
    current_user.feedbacks.find_by_url(params[:id]).destroy
    redirect_to feedbacks_url
  end

  private

    def feedback_params
      params.require(:feedback).permit(:title)
    end

end