# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  email           :string           not null
#  name            :string           not null
#

class User < ActiveRecord::Base
  attr_reader :password

  after_initialize :ensure_session_token

  before_save { self.email = email.downcase }

  validates :username, :session_token, presence: true, uniqueness: true
  validates :password_digest, :email, :name, presence: true

  validates :password,
    length: { minimum: 6, allow_nil: true },
    confirmation: true

  validates :password_confirmation, presence: true

  has_many :subs,
    class_name: "Sub",
    foreign_key: :moderator_id,
    inverse_of: :moderator

  has_many :posts,
    class_name: "Post",
    foreign_key: :author_id,
    inverse_of: :author

  has_many :comments,
    class_name: "Comment",
    foreign_key: :author_id,
    inverse_of: :author

  has_many :votes,
    class_name: "Vote",
    foreign_key: :voter_id,
    inverse_of: :voter

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
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
    SecureRandom.urlsafe_base64
  end
end
