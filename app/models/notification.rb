class Notification < ApplicationRecord
  belongs_to :visitor, class_name: "User",
             foreign_key: :visitor_id
  belongs_to :visitted, class_name: "User",
             foreign_key: :visitted_id
end
