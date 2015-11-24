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

  validates_uniqueness_of :username, :session_token
  validates_presence_of :password_digest, :email, :name

  validates :password,
    length: { minimum: 6, allow_nil: true },
    confirmation: true

  validates_presence_of :password_confirmation, allow_nil: true

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

  def self.find_by_credentials(username, maybe_password)
    user = User.find_by(username: username)

    return nil unless user

    user.is_password?(maybe_password) ? user : nil
  end

  def self.generate_session_token
    SecureRandom.urlsafe_base64
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(maybe_password)
    saved_password = BCrypt::Password.new(self.password_digest)
    saved_password.is_password?(maybe_password)
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
end
