class User < ActiveRecord::Base
  SALT = 'boking123jh766as'
  attr_accessor :password, :password_confirmation

  has_many :bookings

  validates :name, :presence => true

  validates :email,
            :presence => true,
            :uniqueness => true,
            :format => {:with => /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, 
                        :message => 'is invalid'}


  before_validation :check_password_and_confirm_password
  before_create :ensure_authentication_token, :generate_key

  def check_password_and_confirm_password
    if password.blank? or password_confirmation.blank?
      errors.add(:password, "can't be blank") if password.blank?
      errors.add(:password_confirmation, "can't be blank") if password_confirmation.blank?
    else
      if password == password_confirmation
        enc_password = encrypt_password(password)
      else
        errors.add(:password_confirmation, "password and confirm password does not match")
      end
    end
  end

  def valid_password?(pass)
    enc_password == encrypt_password(pass)
  end

 
  def generate_key
    self.assign_secret_key
  end

  def assign_secret_key
    self.secret_key = self.get_secret_key
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = self.generate_authentication_token
    end
  end

  def get_secret_key
    Digest::SHA1.hexdigest(self.email.to_s + self.enc_password.to_s + Digest::SHA1.hexdigest(User::SALT))
  end

  def generate_authentication_token
    loop do
      token = (('a'..'z').to_a + (0..9).to_a).sample(10).join()
      break token unless User.where(authentication_token: token).first
    end
  end

  private
  
  def encrypt_password(pass)
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha1'), User::SALT.encode("ASCII"), pass.encode("ASCII"))
  end



end
