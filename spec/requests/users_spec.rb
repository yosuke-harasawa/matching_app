require 'rails_helper'

RSpec.describe "Users", type: :request do
  
  describe "#new" do
    it "responds successfully" do
      get signup_path
      expect(response).to be_success
    end
  end  
  
  describe "#create" do
    context "when inputted info is invalid" do
      it "is not executed" do
        get signup_path
        expect {
          post signup_path, params: {
            user: {
              name:                  "",
              email:                 "user@invalid",
              password:              "foo",
              password_confirmation: "bar"
            }
          }
        }.to_not change(User, :count)
      end
    end
  
    context "when inputted info is valid" do
      it "is executed" do
        get signup_path
        expect {
          post signup_path, params: {
            user: {
              name:                  "example user",
              email:                 "user@example.com",
              password:              "Password1",
              password_confirmation: "Password1"
            }
          }
        }.to change(User, :count).by(1)
      end 
    end  
  end
  
end  