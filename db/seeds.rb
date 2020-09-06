User.create!(
  name: 'Yosuke',
  email: 'yosuke@example.com',
  password: 'Yosuke7252',
  password_confirmation: 'Yosuke7252',
  admin: true,
  activated: true,
  activated_at: Time.zone.now,
  gender: 'male',
  age: 28,
  prefecture_code: 10,
  nationality: 'Japan'
)

User.create!(
  name: 'Test User',
  email: 'test-user@example.com',
  password: 'Password1',
  password_confirmation: 'Password1',
  activated: true,
  activated_at: Time.zone.now,
  gender: 'male',
  age: 28,
  prefecture_code: 13,
  nationality: 'Japan'
)

99.times do |n|
  name            = Faker::Name.first_name
  email           = "user-#{n + 1}@example.com"
  password        = 'Password1'
  gender          = 'female'
  age             = 23
  prefecture_code = 13
  nationality     = 'Philippines'
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now,
    gender: gender,
    age: age,
    prefecture_code: prefecture_code,
    nationality: nationality
  )
end

Relationship.create!(
  follower_id: 1,
  following_id: 2
)

Relationship.create!(
  follower_id: 2,
  following_id: 1
)

ChatRoom.create!

ChatRoomUser.create!(
  chat_room_id: 1,
  user_id: 1
)

ChatRoomUser.create!(
  chat_room_id: 1,
  user_id: 2
)

100.times do
  Message.create!(
    chat_room_id: 1,
    user_id: 1,
    content: 'Hello👋'
  )
end
