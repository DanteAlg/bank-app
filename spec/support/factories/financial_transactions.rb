FactoryBot.define do
  factory :financial_transaction do
    account
    transfer { nil }
    kind { 'credit' }
    amount { 10000 }
    currency { 'BRL' }
   end
end
