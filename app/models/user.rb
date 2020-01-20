class User < ActiveRecord::Base
	has_one :account

	validates :username, uniqueness: true, presence: true
  validates_presence_of :password_digest

	include BCrypt

  def password
    @password ||= Password.new(password_digest)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_digest = @password
  end
end