FactoryBot.define do
  factory :message do
    user_id { 1 }
    context { 'MyText' }
  end
end
