FactoryBot.define do
  factory :user do
    name                  { "yosuke" }
    email                 { "yosuke@gmail.com" }
    password              { "Yosuke11" }
    password_confirmation { "Yosuke11" }
    admin                 { true }
    activated             { true }
    activated_at          { Time.zone.now }
  end
  
  factory :other_user, class: User do
    name                  { "hiroki" }
    email                 { "hiroki@gmail.com" }
    password              { "Hiroki08" }
    password_confirmation { "Hiroki08" }
    activated             { true }
    activated_at          { Time.zone.now }
  end  
  
  factory :other_users, class: User do
    name                  { "test user" }
    sequence(:email)      { |n| "test#{n}@example.com" }
    password              { "Password1" }
    password_confirmation { "Password1" }
    activated             { true }
    activated_at          { Time.zone.now }
  end  
  
  factory :no_activation_user, class: User do
    name                  { "takuto" }
    email                 { "tak@gmail.com" }
    password              { "Takuto11" }
    password_confirmation { "Takuto11" }
    activated             { false }
    activated_at          { Time.zone.now }
  end
end

