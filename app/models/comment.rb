class Comment < ActiveRecord::Base
  belongs_to :feedback
  validates :content, :feedback_id, presence: true
  accepts_nested_attributes_for :feedback
  default_scope -> { order('created_at DESC') }
end
