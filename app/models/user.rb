class User < ApplicationRecord
  has_many :active_relationships, class_name: "Relationship", 
           foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
           foreign_key: :following_id, dependent: :destroy
  has_many :following, through: :active_relationships
  has_many :followers, through: :passive_relationships
  has_one_attached  :avatar
  # has_many_attached :photos
  attribute :remove_avatar, :boolean
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_save do 
    if remove_avatar
      self.avatar.purge
    end
  end  
  before_create :create_activation_digest
  # before_create :default_avatar
  VALID_EMAIL_REGEX    = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i 
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)[a-zA-Z\d]+\z/

  validates   :name, 
    presence: true,
    length:   { maximum: 30 }
    
  validates     :email, 
    presence:   true,
    length:     { maximum: 50 },
    format:     { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  
  has_secure_password  
  validates   :password,
    presence: true,
    length:   { in: 8..30 },
    format:   { with: VALID_PASSWORD_REGEX },
    allow_nil: true
  
  validates   :gender,
    presence: true
    
  validates   :age,
    presence: true,
    length:   { is: 2 }
    
  validates :prefecture_code,
    presence: true
  
  validates :nationality,
    presence: true
    
  validates :bio,
    length: { maximum: 1000 }
  
  validates :hobby,
    length: { maximum: 100 }
  
  validates :job,
    length: { maximum: 30 }
  
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
  
  def save_hashed_token_in_DB
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end  
  
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end  
  
  def delete_hashed_token_in_DB
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
  end
  
  def following?(other_user)
    following.include?(other_user)
  end  
  
  def matching_users
    User.where(id: passive_relationships.select(:follower_id))
        .where(id: active_relationships.select(:following_id))
  end  
  
  private
  
    def downcase_email
      self.email.downcase!
    end
    
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end  
    
    # def default_avatar
    #   self.avatar.attach(io: File.open(Rails.root.join('app',
    #   'assets', 'images', 'default_avatar.png')), 
    #   filename: 'default_avatar.png', content_type: 'img/png')
    # end  

end
