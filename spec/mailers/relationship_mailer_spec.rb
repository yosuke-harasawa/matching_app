require "rails_helper"

RSpec.describe RelationshipMailer, type: :mailer do
  describe "follower_notification" do
    let(:user)     { create(:user) }
    let(:follower) { create(:other_user) }
    let(:mail)     { RelationshipMailer.follower_notification(user, follower) }
    
    it "フォロー通知メールを送る" do
      expect(mail.subject).to eq "#{follower.name} followed you"
      expect(mail.to).to      eq [user.email]
      expect(mail.from).to    eq ["noreply@example.com"]
      expect(mail.body.encoded).to match(user.name)
      expect(mail.body.encoded).to match(follower.name)
    end
  end  
end
