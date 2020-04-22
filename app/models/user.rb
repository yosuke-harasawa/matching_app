class User < ApplicationRecord
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i 
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)[a-zA-Z\d]+\z/

  validates :name, 
    presence: true,
    length: { maximum: 20 }
    
  validates :email, 
    presence: true,
    length: { maximum: 50 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  
  has_secure_password  
  validates :password,
    presence: true,
    length: { in: 8..30 },
    format: { with: VALID_PASSWORD_REGEX }
end
