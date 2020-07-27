require 'rails_helper'

RSpec.describe 'AccountActivations', type: :system do
  let(:user) { create(:non_activation_user) }

  context 'when account activation is valid' do
    it 'enable to login' do
      visit edit_account_activation_path(user.activation_token, email: user.email)
      expect(user.reload.activated?).to be_truthy
      expect(current_path).to eq user_path(user)
      expect(page).to have_link 'Log out'
      expect(page).to have_content 'Account activated!'
    end
  end

  context 'when still not activate' do
    it 'unable to login' do
      visit login_path
      fill_in 'email',    with: user.email
      fill_in 'password', with: user.password
      click_button 'Log in'
      expect(current_path).to eq root_path
      expect(page).to have_link 'Log in'
      expect(page).to have_content 'Account not activated!'
    end
  end

  context 'when activation token is wrong' do
    it 'unable to login' do
      visit edit_account_activation_path('invalid token', email: user.email)
      expect(user.activated?).to be_falsey
      expect(current_path).to eq root_path
      expect(page).to have_link 'Log in'
      expect(page).to have_content 'Invalid activation link!'
    end
  end

  context 'when email is wrong' do
    it 'unable to login' do
      visit edit_account_activation_path(user.activation_token, email: 'wrong')
      expect(user.activated?).to be_falsey
      expect(current_path).to eq root_path
      expect(page).to have_link 'Log in'
      expect(page).to have_content 'Invalid activation link!'
    end
  end
end
