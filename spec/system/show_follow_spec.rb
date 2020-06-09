require 'rails_helper'

RSpec.describe "ShowFollow", type: :system do
  
  let(:user) { FactoryBot.create(:user) }
  # let!(:relationship) { FactoryBot.create(:relationship) }
  
  def log_in_as(user)
    visit login_path
    fill_in "email",    with: user.email
    fill_in "password", with: user.password
    click_button "Log in"
  end  
  
  it "" do
    log_in_as(user)
    visit followers_user_path(user)
    # expect(user.followers).to_not be_empty
    user.followers.each do |follower|
      expect(page).to have_link follower.name
    end  
  end  
end
