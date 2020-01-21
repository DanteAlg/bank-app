class NotEnoughAccountBalance < StandardError; end

class AccountTransfer
	attr_reader :source_account, :destination_account, :amount, :currency, :transfer

	def initialize(source_account, destination_account, amount)
		@source_account = source_account
		@destination_account = destination_account
		@amount = amount.abs
		@currency = 'BRL'
		@transfer = build_transfer
	end

	def execute
		validate_source_account_balance

		transfer.transaction do
			transfer.save!
			
			create_financial_transaction(FinancialTransaction::KINDS[:debit], source_account)
			create_financial_transaction(FinancialTransaction::KINDS[:credit], destination_account)	
		end

		transfer
	end

	private

	def validate_source_account_balance
		raise NotEnoughAccountBalance if source_account.balance_cents < amount
	end

	def build_transfer
		Transfer.new(
			currency: currency, amount_cents: amount,
			source_account: source_account, destination_account: destination_account
		)
	end

	def create_financial_transaction(kind, account)
		ft = FinancialTransaction.new(kind: kind, account: account, currency: currency, transfer: transfer)
		ft.amount_cents = (ft.debit? ? -amount : amount)
		ft.save!
	end
end