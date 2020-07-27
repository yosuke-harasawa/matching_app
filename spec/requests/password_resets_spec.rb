require 'rails_helper'

RSpec.describe 'PasswordResets', type: :request do
  include ActiveJob::TestHelper

  before do
    ActionMailer::Base.deliveries.clear
  end

  let(:user) { create(:user) }

  describe '#create' do
    context 'when email is invalid' do
      it 'reditect to new password reset path' do
        get new_password_reset_path
        post password_resets_path, params: {
          password_reset: { email: '' }
        }
        expect(request.fullpath).to eq password_resets_path
        expect(flash[:danger]).to be_truthy
      end
    end

    context 'when email is valid' do
      it 'send reset email and redirect to root url' do
        perform_enqueued_jobs do
          get new_password_reset_path
          post password_resets_path, params: {
            password_reset: { email: user.email }
          }
          expect(1).to eq ActionMailer::Base.deliveries.size
          follow_redirect!
          expect(request.fullpath).to eq root_path
          expect(flash[:info]).to be_truthy
        end

        mail = ActionMailer::Base.deliveries.last
        expect(mail.to).to      eq [user.email]
        expect(mail.subject).to eq 'Password reset'
      end
    end
  end

  # describe "#edit" do
  #   context "when email is invalid" do
  #     it "" do
  #     end
  #   end

  #   context "when token is invalid" do
  #     it "" do
  #     end
  #   end
  # end

  # describe "#update" do
  #   before do
  #     get new_password_reset_path
  #     post password_resets_path, params: {
  #       password_reset: { email: user.email }
  #     }
  #     @user = assigns(:user)
  #     get edit_password_reset_path(@user.reset_token, email: user.email)
  #   end

  #   context "when inputted password is empty" do
  #     it "is failed" do
  #       patch password_reset_path(@user.reset_token), params: {
  #         email: user.email,
  #         user: { password: "", password_confirmation: "" }
  #       }
  #       expect(request.fullpath).to eq password_resets_path(@user.reset_token)
  #       expect(flash[:danger]).to be_truthy
  #     end
  #   end
  # end
end
