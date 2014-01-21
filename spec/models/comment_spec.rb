require 'spec_helper'

describe Comment do

  it {should belong_to(:feedback)}
  it {should validate_presence_of(:content)}
  it {should validate_presence_of(:feedback_id)}

  describe "Comment" do
    let(:comment) {Comment.new(content: "Text text text", feedback_id: 1)}

    it "is valid" do
      expect(comment).to be_valid
    end

  end
end
