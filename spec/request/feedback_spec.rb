require 'spec_helper'

describe "Feedback page" do

  let(:user) {FactoryGirl.create(:user)}

  before do
    FactoryGirl.create(:feedback, user: user, title: "Sample title 123")
    FactoryGirl.create(:comment, feedback: user.feedbacks.find(1), content: "Yada yada")
    visit feedback_path(user.feedbacks.find(1))
    fill_in "comment_content", :with => "Blah blah blah"
    click_button "Send feedback"
  end

  let(:feedback) {user.feedbacks.find(1)}
  let(:comment) {feedback.comments.find(1)}

  context "for not signed in users" do

    it "display feedback title" do
      expect(page).to have_content("Sample title 123")
    end

    it "doesn't display comments" do
      expect(page).not_to have_content("You have")
      expect(page).not_to have_content("Yada yada")
    end

    it "submits comment" do
      expect(feedback.comments.count).to eq 2
    end
  end

  context "for signed in users" do

    before do
      visit '/users/sign_in'
      fill_in "user_email", :with => user.email
      fill_in "user_password", :with => 'foobarqwe'
      click_button "Sign in"
      visit feedback_path(feedback)
    end

    it "counts comments" do
      expect(page).to have_content("You have 2 comments")
    end

    it "displays comments" do
      expect(page).to have_content("Yada yada")
      expect(page).to have_content("Blah blah blah")
    end

    it "deletes comments" do
      expect {
        page.driver.submit :delete, feedback_comment_path(feedback, comment), {}
        }.to change {feedback.comments.count}.by -1
      expect(page).to have_content("Comment deleted")
    end

    it "has back link" do
      expect(page).to have_link("Back to list of all feedbacks", href: feedbacks_path)
    end

    describe "it responds with json" do
      before {visit feedback_path(feedback, :json)}

      it "responds with user json" do
        expect(page).to have_content(feedback.to_json)
      end

      it "responds with user comments json" do
        expect(page).to have_content(feedback.comments.to_json)
      end

    end

  end
end
