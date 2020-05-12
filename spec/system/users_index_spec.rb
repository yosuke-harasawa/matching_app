require 'rails_helper'

RSpec.describe "UsersIndex", type: :system do
  
  let(:admin)        { FactoryBot.create(:user) }
  let!(:non_admin)   { FactoryBot.create(:other_user) }
  let!(:other_users) { FactoryBot.create_list(:other_users, 30) }
  
  def log_in_as(user)
    visit login_path
    fill_in "email",    with: user.email
    fill_in "password", with: user.password
    click_button "Log in"
  end  
  
  it "includes pagination" do
    log_in_as(non_admin)
    visit users_path
    expect(page).to have_selector ".pagination"
    users_of_first_page = User.paginate(page: 1)
    users_of_first_page.each do |user|
      expect(page).to have_link href: user_path(user), text: user.name
    end  
  end  
  
  describe "delete links" do
    context "when user is admin" do
      it "are included" do
        log_in_as(admin)
        visit users_path
        expect(page).to have_selector "a[data-method=delete]", text: "delete"
        expect{
          click_link "delete", href: user_path(non_admin)
        }.to change{ User.count }.by(-1)
      end  
    end
    
    context "when user is not admin" do
      it "are not included" do
        log_in_as(non_admin)
        visit users_path
        expect(page).to_not have_selector "a[data-method=delete]", text: "delete"
      end
    end  
  end  
end