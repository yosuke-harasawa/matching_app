require 'rails_helper'

RSpec.describe "Login", type: :system do
  
  let(:user) { FactoryBot.create(:user) }
  
  def submit_invalid_login_info
    fill_in "email",    with: ""
    fill_in "password", with: "foo"
    click_on "Log in"
  end
  
  def submit_valid_login_info
    fill_in "email",    with: user.email
    fill_in "password", with: user.password
    click_on "Log in"
  end
  
  describe "Log in" do
    context "when inputted login info is invalid" do
      it "is failed having a temprary danger flash" do
        visit login_path
        submit_invalid_login_info
        expect(current_path).to eq login_path
        expect(page).to have_selector ".alert-danger"
        visit current_path
        expect(page).to_not have_selector ".alert-danger"
      end
    end
    
    context "when inputted login info is valid" do
      it "is successful " do
        visit login_path
        submit_valid_login_info
        expect(current_path).to eq user_path(user)
      end
    end  
  end
  
  describe "Log out" do
    it "is successful" do
      visit login_path
      submit_valid_login_info
      expect(current_path).to eq user_path(user)
      click_on "Log out"
      expect(current_path).to eq root_path
    end  
  end  
  
end