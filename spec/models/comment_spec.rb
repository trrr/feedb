require 'spec_helper'

describe Comment do

  it {should belong_to(:user)}
  it {should belong_to(:feedback)}
  it {should validate_presence_of(:user_id)}
  it {should validate_presence_of(:content)}
  it {should validate_presence_of(:feedback_id)}
end
