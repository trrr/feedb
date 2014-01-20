require 'spec_helper'

describe Feedback do

  it {should belong_to(:user)}
  it {should have_many(:comments)}
  it {should validate_presence_of(:user_id)}
  it {should respond_to(:title)}


  describe "Feedbback" do

    let(:feedback) {Feedback.new(title: "String", user_id: 1)}

    before {feedback.save}

    it "is valid" do
      feedback.should be_valid
    end

    it "creates valid URL" do
      expect(feedback.url.length).to be 15
    end

    it "uses url as url" do
      expect(feedback.to_param).to eq feedback.url
    end

  end
end
