FactoryBot.define do
  factory :user do
    name                  { "Yosuke" }
    sequence(:email)      { |n| "yosuke#{n}@example.com" }
    password              { "Yosuke11" }
    password_confirmation { "Yosuke11" }
  end
end
