require 'rails_helper'

RSpec.describe "UsersEdit", type: :system do
  
  let(:user)       { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:other_user) }
  
  def log_in_as(user)
    visit login_path
    fill_in "email",    with: user.email
    fill_in "password", with: user.password
    click_button "Log in"
  end  

  context "when user doesn't login" do
    it "redirect to login path" do
      visit edit_user_path(user)
      expect(current_path).to eq login_path
      expect(page).to have_selector ".alert-danger"
    end
    
    it "implement friendly fowarding" do
      visit edit_user_path(user)
      expect(current_path).to eq login_path
      log_in_as(user)
      expect(current_path).to eq edit_user_path(user)
    end  
  end
  
  context "when other user edit profile" do
    it "redirect to root path" do
      log_in_as(other_user)
      visit edit_user_path(user)
      expect(current_path).to eq root_path
    end
  end  
  
  context "when inputted info is invalid" do
    it "is failed" do
      log_in_as(user)
      visit edit_user_path(user)
      fill_in "user name",             with: ""
      fill_in "email",                 with: "user@invalid"
      fill_in "password",              with: "foo"
      fill_in "password confirmation", with: "bar"
      click_button "Update Profile"
      expect(current_path).to eq user_path(user)
      expect(page).to have_selector "#error_explanation"
    end
  end 
  
  context "when inputted info is valid" do
    it "is successful" do
      log_in_as(user)
      visit edit_user_path(user)
      fill_in "user name",             with: "valid user"
      fill_in "email",                 with: "user@valid.com"
      fill_in "password",              with: ""
      fill_in "password confirmation", with: ""
      click_button "Update Profile"
      expect(current_path).to eq user_path(user)
      expect(page).to have_content "Update successful!"
    end
  end  

end
