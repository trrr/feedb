require 'spec_helper'

describe User do
  it {should have_many(:feedbacks)}

  describe "User" do
    let(:user) { FactoryGirl.create(:user) }

    it "is valid" do
      expect(user).to be_valid
    end

    it "sets email" do
      expect(user.email).to eq 'email@example.com'
    end
  end
end
