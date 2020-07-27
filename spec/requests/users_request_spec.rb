require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let!(:user)              { create(:user) }
  let!(:other_user)        { create(:other_user) }
  let(:non_activation_user) { create(:non_activation_user) }

  describe '#index' do
    it '登録していないユーザーも見れる' do
      get users_path
      expect(response).to be_successful
    end

    # it "もし登録していたら自分は表示されない" do
    #   get signup_path
    #   post signup_path, params: {
    #     user: {
    #       name: "user",
    #       email: "user@example.com",
    #       password: "Password1",
    #       password_confirmation: "Password1"
    #     }
    #   }
    #   get users_path
    #   expect(page).to_not have_content
    # end

    it "doesn't display non activation user" do
      log_in_as(user)
      get users_path
      expect(response.body).to_not include non_activation_user.name
    end
  end

  describe '#show' do
    it 'display a user' do
      get user_path(user)
      expect(response).to be_successful
    end

    it "doesn't display non activation user" do
      get user_path(non_activation_user)
      follow_redirect!
      expect(request.fullpath).to eq root_path
    end
  end

  describe '#new' do
    it 'responds successfully' do
      get signup_path
      expect(response).to be_successful
    end
  end

  describe 'admin attribute' do
    it 'is not allowed to edit via the web' do
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

  describe '#destroy' do
    context "when user doesn't login" do
      it 'redirects to login url' do
        expect { delete user_path(user) }.to_not change { User.count }
        redirect_to login_url
      end
    end

    context "when user isn't admin" do
      it 'redirects to root url' do
        log_in_as(other_user)
        expect { delete user_path(user) }.to_not change { User.count }
        redirect_to root_url
      end
    end
  end

  describe 'followers' do
    it 'ログインしていなければログインページにリダイレクトする' do
      get followers_user_path(user)
      follow_redirect!
      expect(request.fullpath).to eq login_path
    end
  end

  describe 'follow_notification' do
    context 'when follow_notification is true' do
      it 'フォロー通知メールを受け取る' do
      end
    end

    context 'when follow_notification is false' do
      it 'フォロー通知メールを受け取らない' do
      end
    end
  end
end
