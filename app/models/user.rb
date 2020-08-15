class User < ApplicationRecord
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: :following_id, dependent: :destroy
  has_many :following, through: :active_relationships
  has_many :followers, through: :passive_relationships
  has_many :chat_room_users, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :active_notifications, class_name: 'Notification',
                                  foreign_key: :visitor_id, dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification',
                                   foreign_key: :visited_id, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy

  attr_accessor :remember_token, :activation_token, :reset_token
  attribute :remove_avatar, :boolean

  before_create :create_activation_digest
  before_save   :downcase_email
  before_create :default_avatar
  before_save do
    if remove_avatar
      avatar.purge
      default_avatar
    end
  end

  VALID_EMAIL_REGEX    = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)[a-zA-Z\d]+\z/.freeze

  validates :name,
            presence: true,
            length: { maximum: 10 }

  validates :gender,
            presence: true

  validates :age,
            presence: true,
            length: { is: 2 }

  validates :prefecture_code,
            presence: true

  validates :nationality,
            presence: true
            
  validates :email,
            presence: true,
            length: { maximum: 50 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  has_secure_password

  validates :password,
            presence: true,
            length: { in: 8..30 },
            format: { with: VALID_PASSWORD_REGEX },
            allow_nil: true

  validates :bio,
            length: { maximum: 1000 }

  validates :hobby,
            length: { maximum: 50 }

  validates :job,
            length: { maximum: 50 }

  include JpPrefecture
  jp_prefecture :prefecture_code

  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name_e)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def save_hashed_token_in_db
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def delete_hashed_token_in_db
    update_attribute(:remember_digest, nil)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def follow(other_user)
    following << other_user
    return unless other_user.follow_notification

    Relationship.send_notification_email(other_user, self)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def matching_users
    User.where(id: passive_relationships.select(:follower_id))
        .where(id: active_relationships.select(:following_id))
  end

  def template
    ApplicationController.renderer.render partial: 'messages/message',
                                          locals: { message: self }
  end

  def create_notification_follow!(current_user)
    temp = Notification.where(['visitor_id = ? and visited_id = ? and action = ?', current_user.id, id, 'follow'])
    return unless temp.blank?

    notification = current_user.active_notifications.new(visited_id: id, action: 'follow')
    notification.save if notification.valid?
  end

  def chat_room?(current_user)
    current_user_chat_rooms = ChatRoomUser.where(user_id: current_user.id).map(&:chat_room)
    chat_room = ChatRoomUser.where(chat_room: current_user_chat_rooms, user_id: id).map(&:chat_room).first
    chat_room.present?
  end

  def show_chat_room(current_user)
    current_user_chat_rooms = ChatRoomUser.where(user_id: current_user.id).map(&:chat_room)
    chat_room = ChatRoomUser.where(chat_room: current_user_chat_rooms, user_id: id).map(&:chat_room).first
    chat_room.id
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def default_avatar
    avatar.attach(io: File.open(Rails.root.join('app/assets/images/default_avatar.png')),
                  filename: 'default_avatar.png', content_type: 'img/png')
  end
end
