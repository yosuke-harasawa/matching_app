require 'rails_helper'

RSpec.describe 'Logins', type: :system do
  let(:user) { create(:user) }

  def submit_invalid_info
    visit login_path
    fill_in 'email',    with: ''
    fill_in 'password', with: 'foo'
    click_button 'Log in'
  end

  def submit_valid_info
    visit login_path
    fill_in 'email',    with: user.email
    fill_in 'password', with: user.password
    click_button 'Log in'
  end

  describe 'Log in' do
    context 'when inputted info is invalid' do
      it 'is failed having a temprary danger flash' do
        submit_invalid_info
        expect(current_path).to eq login_path
        expect(page).to have_selector '.alert-danger'
        visit current_path
        expect(page).to_not have_selector '.alert-danger'
      end
    end

    context 'when inputted info is valid' do
      it 'is successful ' do
        submit_valid_info
        expect(current_path).to eq user_path(user)
      end
    end
  end

  describe 'Log out' do
    it 'is successful' do
      submit_valid_info
      expect(current_path).to eq user_path(user)
      click_link 'Log out'
      expect(current_path).to eq root_path
    end
  end
end
