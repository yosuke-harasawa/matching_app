require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  
  let(:user) { FactoryBot.create(:user) }
  
  def post_login_info(remember_me = 0)
    post login_path, params: {
      session: {
        email:       user.email,
        password:    user.password,
        remember_me: remember_me
      }
    }
  end
  
  it "is temporary when user don't check remember me box" do
    get login_path
    post_login_info(0)
    expect(is_logged_in?).to be_truthy
    expect(cookies[:remember_token]).to be_nil
  end
  
  it "depends on cookies when user check remember me box" do
    get login_path
    post_login_info(1)
    expect(is_logged_in?).to be_truthy
    expect(cookies[:remember_token]).to_not be_nil
  end  
  
  context "when user logout after login with checking remember me box" do
    it "is expired" do
      get login_path
      post_login_info(1)
      expect(is_logged_in?).to be_truthy
      expect(cookies[:remember_token]).to_not be_empty
      delete logout_path
      expect(is_logged_in?).to be_falsey
      expect(cookies[:remember_token]).to be_empty
    end
  end
  
  context "when the site is opened in two tabs or windows" do
    it "is expired at fisrt logout" do
      get login_path
      post_login_info
      follow_redirect!
      expect(request.fullpath).to eq user_path(user)
      expect(is_logged_in?).to be_truthy
      delete logout_path
      follow_redirect!
      expect(request.fullpath).to eq root_path
      expect(is_logged_in?).to be_falsey
      delete logout_path
      follow_redirect!
      expect(request.fullpath).to eq root_path
    end
  end  
end  
    