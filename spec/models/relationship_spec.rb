require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let!(:user)       { create(:user) }
  let!(:other_user) { create(:other_user) }
  let(:active_relationship)  { create(:active_relationship) }
  let(:passive_relationship) { create(:passive_relationship) }

  it '' do
    expect(active_relationship).to be_valid
  end

  it 'フォロワーIDは必須' do
    active_relationship.follower_id = ''
    expect(active_relationship).to_not be_valid
  end

  it 'フォローイングIDは必須' do
    active_relationship.following_id = ''
    expect(active_relationship).to_not be_valid
  end
end
