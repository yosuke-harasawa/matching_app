require "rails_helper"

RSpec.describe MessageMailer, type: :mailer do
  describe "message_notification" do
    let(:reciever)  { create(:user) }
    let(:sender)    { create(:other_user) }
    let(:chat_room) { create(:chat_room) }
    let(:mail)      { MessageMailer.message_notification(reciever, sender, chat_room.id) }
    
    it "メッセージ通知メールを送る" do
      expect(mail.subject).to eq "You've got a new message!"
      expect(mail.to).to      eq [reciever.email]
      expect(mail.from).to    eq ["noreply@example.com"]
      expect(mail.body.encoded).to match(reciever.name)
      expect(mail.body.encoded).to match(sender.name)
    end
  end
end
