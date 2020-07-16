FactoryBot.define do
  factory :chat_user do
    chat_room_id { 1 }
    user_id      { 1 }
  end
  
  factory :chat_partner do
    chat_room_id { 1 }
    user_id      { 2 }
  end  
end
