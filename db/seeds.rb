User.create!(
  name:                  "Yosuke",
  email:                 "yosuke@gmail.com",
  password:              "Yosuke7252",
  password_confirmation: "Yosuke7252",
  admin:                 true,
  activated:             true,
  activated_at:          Time.zone.now,
  gender:                "male",
  age:                   28,
  prefecture_code:       10,
  nationality:           "Japan"
  )
  
99.times do |n|
  name            = Faker::Name.name
  email           = "example-#{n+1}@example.com"
  password        = "Password1"
  gender          = "female"
  age             = 23
  prefecture_code = 13
  nationality     = "Philippines"
  User.create!(
    name:                  name,
    email:                 email,
    password:              password,
    password_confirmation: password,
    activated:             true,
    activated_at:          Time.zone.now,
    gender:                gender,
    age:                   age,
    prefecture_code:       prefecture_code,
    nationality:           nationality
    )
  end  
  
#リレーションシップ
user1 = User.first
user2 = User.secondary
user3 = User.third
user1.follow(user2)
user3.follow(user1)
