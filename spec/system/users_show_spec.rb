require 'rails_helper'

RSpec.describe "UsersShow", type: :system do
  def set_up
    ActionMailer::Base.deliveries.clear
  end
  
  def log_in_as(user)
    visit login_path
    fill_in "email",    with: user.email
    fill_in "password", with: user.password
    click_button "Log in"
  end   
  
  describe "follow" do
    let(:on_user)  { create(:user) }
    let(:off_user) { create(:other_user) }
    
    context "when follow_notification is true" do
      it "フォロー通知メールを送る" do
        log_in_as(off_user)
        visit user_path(on_user)
        click_button "LIKE!" 
        expect(page).to have_button "Requested", disabled: true
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end  
    end
    
    context "when follow_notification is false" do
      it "フォロー通知メールを送らない" do
        log_in_as(on_user)
        visit user_path(off_user)
        click_button "LIKE!" 
        expect(page).to have_button "Requested", disabled: true
        expect(ActionMailer::Base.deliveries.size).to eq 0
      end  
    end
  end
end