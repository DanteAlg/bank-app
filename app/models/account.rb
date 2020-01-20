class Account < ActiveRecord::Base
	has_many :financial_transactions

  belongs_to :user

  validates_presence_of :number, :user

  def balance
    financial_transactions.sum(:amount)
  end
end