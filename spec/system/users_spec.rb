require 'rails_helper'

RSpec.describe "Users", type: :system do
  
  describe "signup" do
    context "when inputted info is invalid" do
      it "is failed" do
        visit signup_path
        fill_in "user name",             with: ""
        fill_in "email",                 with: "user@example.com"
        fill_in "password",              with: "Password1"
        fill_in "password confirmation", with: "Password1"
        click_button "Sign up"
        
        expect(current_path).to eq signup_path
        expect(page).to have_selector "#error_explanation"
      end
    end  
    
    context "when inputted info is valid" do
      it "is successful" do
        visit signup_path
        fill_in "user name",             with: "user"
        fill_in "email",                 with: "user@example.com"
        fill_in "password",              with: "Password1"
        fill_in "password confirmation", with: "Password1"
        click_button "Sign up"
        
        expect(current_path).to eq user_path(1)
        expect(page).to_not have_selector "#error_explanation"
      end 
    end  
  end
  
end
