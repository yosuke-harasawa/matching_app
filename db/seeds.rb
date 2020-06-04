User.create!(
  name:                  "Yosuke",
  email:                 "yosuke@gmail.com",
  password:              "Yosuke7252",
  password_confirmation: "Yosuke7252",
  admin:                 true,
  activated:             true,
  activated_at:          Time.zone.now
  )
  
99.times do |n|
  name        = Faker::Name.name
  email       = "example-#{n+1}@example.com"
  password    = "Password1"
  nationality = "Philippines"
  User.create!(
    name:                  name,
    email:                 email,
    password:              password,
    password_confirmation: password,
    activated:             true,
    activated_at:          Time.zone.now,
    nationality:           nationality
    )
  end  