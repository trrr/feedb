module FeedbacksHelper
  def belongs_to_current_user?
    if user_signed_in?
      current_user.id.to_i == @feedback.user_id.to_i
    end
  end

  def amount_of_comments
    if @comments.any?
      "You don't have any comments yet."
    else
      "You have #{pluralize(@feedback.comments.count, "comment")}:"
    end
  end

end
