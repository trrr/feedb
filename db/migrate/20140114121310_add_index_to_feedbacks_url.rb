class AddIndexToFeedbacksUrl < ActiveRecord::Migration
  def change
    add_index :feedbacks, :url, unique: true
  end
end
