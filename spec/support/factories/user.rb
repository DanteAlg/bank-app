require 'securerandom'

FactoryBot.define do
  factory :user do
    sequence :username do |n|
      "username-#{n}"
    end
    password { '123456' }
  end
end
