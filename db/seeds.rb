User.create!(
  name:                  "yosuke",
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
  email           = "user-#{n+1}@example.com"
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
  
  Relationship.create!(
    follower_id: 1,
    following_id: 2
    )
    
  Relationship.create!(
    follower_id: 2,
    following_id: 1
    )
    
  ChatRoom.create!(
    )  
    
  ChatRoomUser.create!(
    chat_room_id: 1,
    user_id: 1
    )  
    
  ChatRoomUser.create!(
    chat_room_id: 1,
    user_id: 2
    )  

  100.times do |n|
    Message.create!(
      chat_room_id: 1,
      user_id: 1,
      content: "Hello World"
      )
  end   