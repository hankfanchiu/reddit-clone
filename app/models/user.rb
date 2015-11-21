# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  user_name       :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  attr_reader :password

  after_initialize :ensure_session_token

  validates :user_name, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: true

  has_many :subs, class_name: "Sub", foreign_key: :moderator_id
  has_many :posts, class_name: "Post", foreign_key: :author_id

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    if user.nil?
      nil
    else
      user.is_password?(password) ? user : nil
    end
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    saved_password = BCrypt::Password.new(self.password_digest)
    saved_password.is_password?(password)
  end

  def reset_session_token!
    self.session_token = generate_session_token
    self.save!
    self.session_token
  end

  private

  def ensure_session_token
    self.session_token ||= generate_session_token
  end

  def generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

end










#
