class Account < ActiveRecord::Base
  has_many :financial_transactions

  belongs_to :user

  validates_presence_of :number, :user

  def balance_cents
    financial_transactions.sum(:amount_cents)
  end
end
