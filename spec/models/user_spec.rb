require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }
  it "sets email" do
    expect(user.email).to eq 'email@example.com'
  end

  it {should have_many(:feedbacks)}
  it {should have_many(:comments).through(:feedbacks)}

end
