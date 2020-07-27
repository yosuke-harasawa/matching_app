require 'rails_helper'

RSpec.describe 'UsersIndex', type: :system do
  let(:admin)        { create(:user) }
  let!(:non_admin)   { create(:other_user) }
  let!(:other_users) { create_list(:other_users, 40) }

  def log_in_as(user)
    visit login_path
    fill_in 'email',    with: user.email
    fill_in 'password', with: user.password
    click_button 'Log in'
  end

  it 'has paginations' do
    visit users_path
    expect(page).to have_css '.pagination'
  end

  it 'has users links' do
    visit users_path
    users_of_first_page = User.page(1)
    users_of_first_page.each do |user|
      expect(page).to have_link href: user_path(user), text: user.name
    end
  end

  context 'when user log in' do
    it "doesn't display self" do
      log_in_as(non_admin)
      visit users_path
      expect(page).to_not have_link non_admin.name, href: user_path(non_admin)
    end
  end

  describe 'delete links' do
    context 'when user is admin' do
      it 'displayed' do
        log_in_as(admin)
        visit users_path
        expect(page).to have_selector 'a[data-method=delete]', text: 'delete'
        expect { click_link 'delete', href: user_path(non_admin) }.to change { User.count }.by(-1)
      end
    end

    context 'when user is not admin' do
      it 'not displayed' do
        log_in_as(non_admin)
        visit users_path
        expect(page).to_not have_selector 'a[data-method=delete]', text: 'delete'
      end
    end
  end
end
