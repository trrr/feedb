require 'spec_helper'

describe "Application"  do

  subject { page }

  describe "Home page" do

    before { visit root_path }

    it "prompts you to sign in or sign up" do
      expect(page).to have_selector 'p.g-alert', text: 'You need to sign in or sign up before continuing.'
    end

    describe "for not-signed in users" do

      it {current_path.should == '/users/sign_in'}
      it {should have_content('Sign in')}

    end

    describe "for signed in users" do
      let(:user) {FactoryGirl.create(:user)}

      before do
        
        FactoryGirl.create(:feedback, user: user, title: "Sample title 123")
        FactoryGirl.create(:comment, feedback: user.feedbacks.find(1), content: "Yada yada")


        visit '/users/sign_in'
        fill_in "user_email", :with => user.email
        fill_in "user_password", :with => 'foobarqwe'
        click_button "Sign in"

        visit root_path
      end

      it {should have_content('List of all feedbacks')}

      it "shows feedback" do 
        expect(page).to have_selector('h2 a', text: "Sample title 123")
      end

      it "counts comments" do
        expect(page).to have_selector('h2 div', text: "1 comment")
      end

      it "creates new feedback" do
        fill_in "feedback_title", :with => "New feedback title"
        click_button "Create new feedback"
        expect(page).to have_content("New feedback title")
        expect(page).to have_content("New feedback has been successfully created")
      end

      it "has second comment" do
        visit '/'
        expect(page).to have_content("/feedbacks/#{user.feedbacks.find(1).url}")
        expect(page).to have_content("Sample title 123")
      end


      it "deletes feedback" do
        page.driver.submit :delete, "/feedbacks/#{user.feedbacks.find(1).url}", {}
        expect(page).not_to have_content("Sample title 123")
      end

    end
  end

  describe "Feedback page" do
    let(:user) {FactoryGirl.create(:user)}
    before do 
      FactoryGirl.create(:feedback, user: user, title: "Sample title 123")
      FactoryGirl.create(:comment, feedback: user.feedbacks.find(1), content: "Yada yada")
      visit feedback_path(user.feedbacks.find(1))
      fill_in "comment_content", :with => "Blah blah blah"
      click_button "Send feedback"
    end

    describe "for not signed in users" do
      it {should have_content("Sample title 123")}

      it "doesn't display comments" do
        expect(page).not_to have_content("You have")
        expect(page).not_to have_content("Yada yada")
      end

      it "submits comment" do
        expect(user.feedbacks.find(1).comments.count).to eq 2
      end
    end

    describe "for signed in users" do
      before do
        visit '/users/sign_in'
        fill_in "user_email", :with => user.email
        fill_in "user_password", :with => 'foobarqwe'
        click_button "Sign in"
        visit feedback_path(user.feedbacks.find(1))
      end

      it "counts comments" do
        expect(page).to have_content("You have 2 comments")
      end

      it "displays comments" do
        expect(page).to have_content("Yada yada")
        expect(page).to have_content("Blah blah blah")
      end

      it "deletes comments" do
        page.driver.submit :delete, "/feedbacks/#{user.feedbacks.find(1).url}", {}
        expect(page).to have_no_content("Yada yada")
      end

      it "has back link" do 
        expect(page).to have_link("Back to list of all feedbacks", href: feedbacks_path)
      end

      it "responds with user json" do
        visit feedback_path(user.feedbacks.find(1))+".json"
        expect(page).to have_content(user.feedbacks.find(1).to_json)
      end

      it "responds with user comments json" do
        visit feedback_path(user.feedbacks.find(1))+".json"
        expect(page).to have_content(user.feedbacks.find(1).comments.to_json)
      end

    end

  end
end