require 'rails_helper'

RSpec.describe "Users", type: :request do
  
  let!(:user)       { FactoryBot.create(:user) } 
  let!(:other_user) { FactoryBot.create(:other_user) }
  
  describe "#new" do
    it "responds successfully" do
      get signup_path
      expect(response).to be_successful
    end
  end  
  
  describe "admin attribute" do
    it "is not allowed to edit via the web" do
      log_in_as(other_user)
      expect(other_user.admin?).to be_falsey
      patch user_path(other_user), params: {
        user: {
          admin: true
        }
      }
      expect(other_user.admin?).to be_falsey
    end  
  end  
  
  describe "#destroy" do
    context "when user doesn't login" do
      it "redirects to login url" do
        expect{
          delete user_path(user)
        }.to_not change{ User.count }
        redirect_to login_url
      end
    end
    
    context "when user isn't admin" do
      it "redirects to root url" do
        log_in_as(other_user)
        expect{
          delete user_path(user)
        }.to_not change{ User.count }
        redirect_to root_url
      end
    end  
  end  
  
end  