require 'rails_helper'

RSpec.describe User, type: :model do
  
  let(:user){ 
    User.new(
      name:                  "Yosuke",
      email:                 "yosuke@example.com",
      password:              "Yosuke11",
      password_confirmation: "Yosuke11"
    )
  }  
  
  describe "User" do
    it "has a valid factory" do
      expect(user).to be_valid
    end
  end  
    
  describe "name" do
    it "can't be blank" do
      user.name = ""
      expect(user).to  be_invalid
    end
    
    context "20 characters" do
      it "is maximum length" do
        user.name = "a" * 20
        expect(user).to be_valid
      end
    end
    
    context "21 characters" do
      it "is too long" do
        user.name = "a" * 21
        expect(user).to be_invalid
      end  
    end 
  end  
    
  describe "email" do
    it "can't be blank" do
      user.email = ""
      expect(user).to be_invalid
    end
    
    context "50 characters" do
      it "is maximum length" do
        user.email = "a" * 38 + "@example.com"
        expect(user).to be_valid
      end
    end
    
    context "51 characters" do
      it "is too long" do
        user.email = "a" * 39 + "@example.com"
        expect(user).to be_invalid
      end
    end  
    
    it "accept valid form" do
      user.email = "user@example.com"
      expect(user).to be_valid
      
      user.email = "USER@foo.COM"
      expect(user).to be_valid
      
      user.email = "A_US-ER@foo.bar.org"
      expect(user).to be_valid
      
      user.email = "first.last@foo.jp"
      expect(user).to be_valid
      
      user.email = "alice+bob@baz.cn"
      expect(user).to be_valid
    end  
    
    it "refuse invalid form" do
      user.email = "user@example,com"
      expect(user).to be_invalid
      
      user.email = "user_at_foo.org"
      expect(user).to be_invalid
      
      user.email = "user.name@example."
      expect(user).to be_invalid
      
      user.email = "foo@bar_baz.com"
      expect(user).to be_invalid
      
      user.email = "foo@bar+baz.com"
      expect(user).to be_invalid
      
      user.email = "foo@bar..com"
      expect(user).to be_invalid
    end  
    
    it "is unique" do
      duplicate_user = user.dup
      duplicate_user.email = user.email.upcase
      user.save!
      expect(duplicate_user).to be_invalid
    end  
    
    it "is saved as lower-case" do
      user.email = "Yosuke@ExAMPle.CoM"
      user.save!
      expect(user.reload.email).to eq "yosuke@example.com"
    end  
  end
  
  describe "password and password_confirmation" do
    it "can't be blank" do
      user.password              = ""
      user.password_confirmation = ""
      expect(user).to be_invalid
    end
    
    context "8 characters" do
      it "is minimum length" do
        user.password              = "Yosuke11"
        user.password_confirmation = "Yosuke11"
        expect(user).to be_valid
      end
    end
    
    context "7 characters" do
      it "is too short" do
        user.password              = "Yosuke1"
        user.password_confirmation = "Yosuke1"
        expect(user).to be_invalid
      end
    end  
    
    context "30 characters" do
      it "is maximum length" do
        user.password              = "Yo1" * 10
        user.password_confirmation = "Yo1" * 10
        expect(user) .to be_valid
      end
    end
    
    context "31 characters" do
      it "is too long" do
        user.password              = "Yo1" * 10 + "y"
        user.password_confirmation = "Yo1" * 10 + "y"
        expect(user).to be_invalid
      end
    end  
    
    it "accept valid form" do
      user.password = user.password_confirmation = "Yosuke11"
      expect(user).to be_valid
      
      user.password = user.password_confirmation = "11YoS12UkE"
      expect(user).to be_valid
    end
    
    it "refuse invalid form" do
      user.password = user.password_confirmation = "yosuke.harasawa"
      expect(user).to be_invalid
      
      user.password = user.password_confirmation = "Yosuke-Harasawa"
      expect(user).to be_invalid
      
      user.password = user.password_confirmation = "12345678"
      expect(user).to be_invalid
      
      user.password = user.password_confirmation = "yosuke_11"
      expect(user).to be_invalid
      
      user.password = user.password_confirmation = "YOSUKE@11"
      expect(user).to be_invalid
      
      user.password = user.password_confirmation = "Yosuke.11"
      expect(user).to be_invalid
    end
  end
  
end  
