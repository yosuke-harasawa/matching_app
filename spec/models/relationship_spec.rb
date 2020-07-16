require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let!(:user)       { create(:user) }
  let!(:other_user) { create(:other_user) }
  let(:relationship){ 
    Relationship.new(
      follower_id:  1,
      following_id: 2
    )
  }    
  
  it "" do
    expect(relationship).to be_valid
  end
  
  it "フォロワーIDは必須" do
    relationship.follower_id = ""
    expect(relationship).to_not be_valid
  end

  it "フォローイングIDは必須" do
    relationship.following_id = ""
    expect(relationship).to_not be_valid
  end
end
