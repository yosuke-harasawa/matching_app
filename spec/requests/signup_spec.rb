require 'rails_helper'

RSpec.describe "Signup", type: :request do

  def signup_with_invalid_info
    get signup_path
    post signup_path, params: {
      user: {
        name:                  "",
        email:                 "user@invalid",
        password:              "foo",
        password_confirmation: "bar"
      }
    }
  end  
  
  def signup_with_valid_info
    get signup_path
    post signup_path, params: {
      user: {
        name:                  "user",
        email:                 "user@example.com",
        password:              "Password1",
        password_confirmation: "Password1",
        gender:                "male",
        age:                   "28",
        prefecture_code:       "10",
        nationality:           "Japan"
      }
    }
  end  
  
  def setup
    ActionMailer::Base.deliveries.clear
  end

  context "when inputted info is invalid" do
    it "is failed" do
      expect{ signup_with_invalid_info }.to_not change{ User.count }
      expect(request.fullpath).to eq signup_path
    end  
  end  

  context "when inputted info is valid" do
    it "is successful" do
      expect{ signup_with_valid_info }.to change{ User.count }.by(1)
      expect(1).to eq ActionMailer::Base.deliveries.size
      follow_redirect!
      expect(request.fullpath).to eq root_path
      expect(flash[:info]).to be_truthy
    end
    
    describe "account activation" do

      let(:user) { FactoryBot.create(:no_activation_user) }

      context "when account activation is valid" do
        it "enable to login" do
          get edit_account_activation_path(user.activation_token, email: user.email)
          expect(user.reload.activated?).to be_truthy
          expect(is_logged_in?).to be_truthy
          follow_redirect!
          expect(request.fullpath).to eq user_path(user)
        end  
      end 
      
      context "when still not activate" do
        it "unable to login" do
          log_in_as(user)
          expect(is_logged_in?).to be_falsey
          follow_redirect!
          expect(request.fullpath).to eq root_path
        end
      end
      
      context "when activation token is wrong" do
        it "unable to login" do
          get edit_account_activation_path("invalid token", email: user.email)
          expect(user.activated?).to be_falsey
          expect(is_logged_in?).to be_falsey
          follow_redirect!
          expect(request.fullpath).to eq root_path
        end
      end
      
      context "when email is wrong" do
        it "unable to login" do
          get edit_account_activation_path(user.activation_token, email: "wrong")
          expect(user.activated?).to be_falsey
          expect(is_logged_in?).to be_falsey
          follow_redirect!
          expect(request.fullpath).to eq root_path
        end
      end 
    end  
  end
end  
      