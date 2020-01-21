class FinancialTransaction < ActiveRecord::Base
	belongs_to :account
	belongs_to :transfer

	KINDS = { debit: 'debit', credit: 'credit' }

	validates_presence_of :amount_cents, :currency, :account
	validates :amount_cents, numericality: { greater_than: 0 }, if: :credit?
	validates :amount_cents, numericality: { less_than: 0 }, if: :debit?
	validates :kind, inclusion: { in: KINDS.values }

	def debit?
		kind == KINDS[:debit]
	end

	def credit?
		kind == KINDS[:credit]
	end
end