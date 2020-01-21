FactoryBot.define do
  factory :transfer do
    source_account { FactoryBot.build(:account) }
    destination_account { FactoryBot.build(:account) }
    amount_cents { 10000 }
    currency { 'BRL' }
   end
end
