require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  
  let(:user) { create(:user) }
  
  describe "Log in" do
    context "when inputted login info is invalid" do
      it "is failed having a temprary danger flash" do
        visit login_path
        fill_in "email",    with: ""
        fill_in "password", with: "foo"
        click_on "Log in"
        
        expect(current_path).to eq login_path
        expect(page).to have_selector ".alert-danger"
        visit current_path
        expect(page).to_not have_selector ".alert-danger"
      end
    end
    
    context "when inputted login info is valid" do
      it "is successful " do
        visit login_path
        fill_in "email",    with: user.email
        fill_in "password", with: user.password
        click_on "Log in"
        
        expect(current_path).to eq user_path(user)
      end
    end  
  end
  
  describe "Log out" do
    it "" do
      visit login_path
      fill_in "email",    with: user.email
      fill_in "password", with: user.password
      click_on "Log in"
      
      expect(current_path).to eq user_path(user)
      click_on "Log out"
      expect(current_path).to eq root_path
    end  
  end  
  
end