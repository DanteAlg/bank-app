require_relative '../spec_helper.rb'

describe Account do
	describe '#validations' do
		let(:resource) { FactoryBot.build(:account) }

		shared_examples 'must be present' do |field|
			it "validate #{field} presence" do
				resource.send("#{field}=", nil)
				resource.valid?
				expect(resource.errors.messages).to eq({field.to_sym => ["can't be blank"]})
			end
		end

		include_examples 'must be present', 'user'
		include_examples 'must be present', 'number'
	end

	describe '#balance' do
		let(:account) { FactoryBot.build(:account) }
		let!(:transaction_1) do
			FactoryBot.create(:financial_transaction, account: account, amount: 1000,
				kind: FinancialTransaction::KINDS[:credit])
		end
		let!(:transaction_2) do
			FactoryBot.create(:financial_transaction, account: account, amount: 3000,
				kind: FinancialTransaction::KINDS[:credit])
		end
		let!(:transaction_3) do
			FactoryBot.create(:financial_transaction, account: account, amount: -2050,
				kind: FinancialTransaction::KINDS[:debit])
		end

		it 'sum account financial transactions' do
			expect(account.balance).to eq(1950)
		end
	end
end