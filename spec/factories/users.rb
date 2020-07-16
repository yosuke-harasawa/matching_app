FactoryBot.define do
  factory :user do
    name                  { "yosuke" }
    email                 { "yosuke@gmail.com" }
    password              { "Yosuke11" }
    password_confirmation { "Yosuke11" }
    gender                { "male" }
    age                   { 28 }
    prefecture_code       { 10 }
    nationality           { "Japan" }
    admin                 { true }
    activated             { true }
    activated_at          { Time.zone.now }
    follow_notification   { true }
    message_notification  { true }
  end
  
  factory :other_user, class: User do
    name                  { "hiroki" }
    email                 { "hiroki@gmail.com" }
    password              { "Hiroki08" }
    password_confirmation { "Hiroki08" }
    gender                { "male" }
    age                   { 28 }
    prefecture_code       { 10 }
    nationality           { "Japan" }
    activated             { true }
    activated_at          { Time.zone.now }
    follow_notification   { false }
  end  
  
  factory :other_users, class: User do
    name                  { "test user" }
    sequence(:email)      { |n| "test#{n}@example.com" }
    password              { "Password1" }
    password_confirmation { "Password1" }
    gender                { "female" }
    age                   { 23 }
    prefecture_code       { 10 }
    nationality           { "Philippines" }
    activated             { true }
    activated_at          { Time.zone.now }
  end  
  
  factory :no_activation_user, class: User do
    name                  { "takuto" }
    email                 { "tak@gmail.com" }
    password              { "Takuto11" }
    password_confirmation { "Takuto11" }
    gender                { "male" }
    age                   { "22" }
    prefecture_code       { 10 }
    nationality           { "Japan" }
    activated             { false }
    activated_at          { Time.zone.now }
  end
end

