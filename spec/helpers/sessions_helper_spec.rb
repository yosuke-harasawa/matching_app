require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  let(:user) { create(:user) }

  describe '#current_user' do
    context 'when cookies are present' do
      it 'returns right user' do
        save_info_in_cookies(user)
        expect(current_user).to eq user
        expect(is_logged_in?).to be_truthy
      end
    end

    context "when remember digest and cookies token doesn't match" do
      it 'returns nil' do
        save_info_in_cookies(user)
        user.update_attribute(:remember_digest, User.digest(User.new_token))
        expect(current_user).to be_nil
      end
    end
  end
end
