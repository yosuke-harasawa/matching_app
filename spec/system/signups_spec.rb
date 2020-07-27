require 'rails_helper'

RSpec.describe 'Signups', type: :system do
  include ActiveJob::TestHelper

  before do
    visit root_path
    click_link 'Sign up'
    expect(current_path).to eq signup_path
  end

  context 'when inputted info is invalid' do
    it 'is failed' do
      fill_in 'user name',             with: ''
      fill_in 'age',                   with: 3
      select                           '-----', from: 'Area'
      select                           '-----', from: 'Nationality'
      fill_in 'email',                 with: 'user@invalid'
      fill_in 'password',              with: 'foo'
      fill_in 'password confirmation', with: 'bar'
      expect { click_button 'Sign up' }.to_not change { User.count }

      expect(current_path).to eq signup_path
      expect(page).to have_selector '#error_explanation'
    end
  end

  context 'when inputted info is valid' do
    before do
      ActionMailer::Base.deliveries.clear
    end

    it 'is successful and send an activation email' do
      perform_enqueued_jobs do
        fill_in 'user name',             with: 'user'
        fill_in 'age',                   with: 28
        choose                           'male'
        select                           'Gunma', from: 'Area'
        select                           'Japan', from: 'Nationality'
        fill_in 'email',                 with: 'user@example.com'
        fill_in 'password',              with: 'Password1'
        fill_in 'password confirmation', with: 'Password1'
        expect { click_button 'Sign up' }.to change { User.count }.by(1)

        expect(1).to eq ActionMailer::Base.deliveries.size
        expect(current_path).to eq root_path
        expect(page).to have_content 'Please check your email to activate your account'
      end

      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to      eq ['user@example.com']
      expect(mail.subject).to eq 'Account activation'
    end
  end
end
