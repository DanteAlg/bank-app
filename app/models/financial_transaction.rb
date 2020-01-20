class FinancialTransaction < ActiveRecord::Base
	belongs_to :account
	belongs_to :transfer

	KINDS = { debit: 'debit', credit: 'credit' }

	validates_presence_of :amount, :currency, :account
	validates :amount, numericality: { greater_than: 0 }, if: :credit?
	validates :amount, numericality: { less_than: 0 }, if: :debit?
	validates :kind, inclusion: { in: KINDS.values }

	def debit?
		kind == KINDS[:debit]
	end

	def credit?
		kind == KINDS[:credit]
	end
end