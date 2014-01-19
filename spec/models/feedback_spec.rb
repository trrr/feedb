require 'spec_helper'

describe Feedback do

  it {should belong_to(:user)}
  it {should have_many(:comments)}
  it {should validate_presence_of(:user_id)}
  it {should respond_to(:title)}

  describe "URL" do

    let(:feedback) {Feedback.new}

    it "creates valid URL" do
      feedback.save
      expect(feedback.url.length).to be 15
    end


  end
end
