require 'spec_helper'

describe "Home page" do

  subject { page }
  before { visit root_path }

  context "for not-signed in users" do

    it "prompts you to sign in or sign up" do
      expect(page).to have_selector 'p.g-alert', text: 'You need to sign in or sign up before continuing.'
    end

    it {current_path.should == '/users/sign_in'}
    it {should have_content('Sign in')}

  end

  context "for signed in users" do

    let(:user) {FactoryGirl.create(:user)}

    before do

      FactoryGirl.create(:feedback, user: user, title: "Sample title 123")
      FactoryGirl.create(:comment, feedback: user.feedbacks.find(1), content: "Yada yada")


      visit '/users/sign_in'
      fill_in "user_email", :with => user.email
      fill_in "user_password", :with => 'foobarqwe'
      click_button "Sign in"
    end

    it {should have_content('List of all feedbacks')}

    it "shows feedback" do
      expect(page).to have_selector('h2 a', text: "Sample title 123")
    end

    it "displays url of the feedback" do
      expect(page).to have_content("/feedbacks/#{user.feedbacks.find(1).url}")
    end

    it "counts comments" do
      expect(page).to have_selector('h2 div', text: "1 comment")
    end

    describe "it creates new feedback" do

      before do
        expect {
          fill_in "feedback_title", :with => "New feedback title"
          click_button "Create new feedback"
        }.to change{user.feedbacks.count}.by 1
      end

      it "shows flash success message" do
        expect(page).to have_content("New feedback has been successfully created")
      end

      it "displays new created feedback" do
        expect(page).to have_content("New feedback title")
      end

      it "displays url of new feedback" do
        visit '/'
        expect(page).to have_content("/feedbacks/#{user.feedbacks.find(2).url}")
      end
    end

    describe "it deletes feedback" do
      before do
        expect {
          page.driver.submit :delete, "/feedbacks/#{user.feedbacks.find(1).url}", {}
          }.to change {user.feedbacks.count}.by -1
      end

      it "doesn't show deleted feedback" do
        expect(page).not_to have_content("Sample title 123")
      end
    end

  end
end
