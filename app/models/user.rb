class User < ActiveRecord::Base
  has_secure_password
  has_one :account

  validates :username, uniqueness: true, presence: true
  validates_presence_of :password_digest
end
