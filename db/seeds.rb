User.create!(
  name:                  "Yosuke",
  email:                 "yosuke@gmail.com",
  password:              "Yosuke7252",
  password_confirmation: "Yosuke7252",
  admin:                 "true"
  )
  
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@example.com"
  password = "Password1"
  User.create!(
    name:                  name,
    email:                 email,
    password:              password,
    password_confirmation: password
    )
  end  