require 'rails_helper'

RSpec.describe "Signup", type: :system do
  
  context "when inputted info is invalid" do
    it "is failed" do
      visit signup_path
      fill_in "user name",             with: ""
      fill_in "email",                 with: "user@invalid"
      fill_in "password",              with: "foo"
      fill_in "password confirmation", with: "bar"
      
      expect {
        click_on "Sign up"
      }.to_not change(User, :count)
      expect(current_path).to eq signup_path
      expect(page).to have_selector "#error_explanation"
    end
  end  
  
  context "when inputted info is valid" do
    it "is successful and also login" do
      visit signup_path
      fill_in "user name",             with: "user"
      fill_in "email",                 with: "user@example.com"
      fill_in "password",              with: "Password1"
      fill_in "password confirmation", with: "Password1"
      
      expect {
        click_on "Sign up"
      }.to change(User, :count).by(1)
      user = User.last
      expect(current_path).to eq user_path(user)
      expect(page).to have_content "Welcome to the meet app!"
      expect(page).to have_selector ".profile-link"
    end 
  end  
  
end
