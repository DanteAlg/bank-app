require 'securerandom'

FactoryBot.define do
  factory :account do
    sequence :number do |n|
      "num-123#{n}"
    end
    user
  end
end
