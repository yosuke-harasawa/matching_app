FactoryBot.define do
  factory :active_relationship, class: Relationship do
    follower_id  { 1 }
    following_id { 2 }
  end

  factory :passive_relationship, class: Relationship do
    follower_id  { 2 }
    following_id { 1 }
  end
end
