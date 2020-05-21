require 'rails_helper'

RSpec.describe "PasswordResets", type: :system do
  
  let(:user) { FactoryBot.create(:user) }
  
  describe "#create" do
    context "when email is invalid" do
      it "reditect to new password reset path" do
        visit new_password_reset_path
        fill_in :email, with: ""
        click_button "Submit"
        expect(current_path).to eq password_resets_path
        expect(page).to have_selector ".alert-danger"
      end  
    end  
    
    context "when email is valid" do
      it "redirect to root url" do
        visit new_password_reset_path
        fill_in :email, with: user.email
        click_button "Submit"
        expect(current_path).to eq root_path
        expect(page).to have_selector ".alert-info"
      end
    end
  end
  
  # describe "#update" do
  #   context "when inputted passwprd is empty" do
  #     it "is faled" do
  #       user = assigns(:user)
  #       visit edit_password_reset_url(user.reset_token, email: user.email)
  #       fill_in :password,              with: ""
  #       fill_in :password_confirmation, with: ""
  #       click_button "Update password"
  #       expect(current_path).to eq password_resets_path(user.reset_token)
  #       expect(page).to have_selector ".alert-danger"
  #     end  
  #   end
  # end  
  
end
