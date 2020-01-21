FactoryBot.define do
  factory :financial_transaction do
    account
    transfer { nil }
    kind { 'credit' }
    amount_cents { 10000 }
    currency { 'BRL' }
   end
end
