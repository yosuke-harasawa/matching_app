require 'rails_helper'

RSpec.describe 'RoomsShow', type: :system do
  def set_up
    ActionMailer::Base.deliveries.clear
  end

  def log_in_as(user)
    visit login_path
    fill_in 'email',    with: user.email
    fill_in 'password', with: user.password
    click_button 'Log in'
  end

  describe 'Submit' do
    let!(:user)                  { create(:user) }
    let!(:matching_user)         { create(:other_user) }
    let!(:active_relationship)   { create(:active_relationship) }
    let!(:passive_relationship)  { create(:passive_relationship) }

    it 'メッセージ通知メールを送る' do
      log_in_as(user)
      visit matchers_user_path(user)
      expect(page).to have_link matching_user.name
      expect(page).to have_button 'Chat'
      click_button 'Chat'
      expect(current_path).to eq room_path(chat_room.id)
      expect(page).to have_button 'Submit', disabled: true
      fill_in 'message_content', with: 'message'
      expect(page).to have_button 'Submit', disabled: false
      click_button 'Submit'
    end
  end
end
