require 'rails_helper'

RSpec.describe Relationship, type: :model do
  
  let(:relationship){ 
    Relationship.new(
      follower_id:  1,
      following_id: 2
    )
  }    
  
  it "" do
    expect(relationship).to be_valid
  end
  
  it "require follower_id" do
    relationship.follower_id = ""
    expect(relationship).to_not be_valid
  end

  it "require following_id" do
    relationship.following_id = ""
    expect(relationship).to_not be_valid
  end
end
