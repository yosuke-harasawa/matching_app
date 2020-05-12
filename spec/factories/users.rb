FactoryBot.define do
  factory :user do
    name                  { "yosuke" }
    email                 { "yosuke@gmail.com" }
    password              { "Yosuke11" }
    password_confirmation { "Yosuke11" }
    admin                 { true }
  end
  
  factory :other_user, class: User do
    name                  { "hiroki" }
    email                 { "hiroki@gmail.com" }
    password              { "Hiroki08" }
    password_confirmation { "Hiroki08" }
  end  
  
  factory :other_users, class: User do
    name                  { "test user" }
    sequence(:email)      { |n| "test#{n}@example.com" }
    password              { "Password1" }
    password_confirmation { "Password1" }
  end  
end
