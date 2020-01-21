require_relative '../../spec_helper.rb'

describe AccountTransfer do
	describe '#execute' do
		let!(:source_account) { FactoryBot.create(:account) }
		let!(:destination_account) { FactoryBot.create(:account) }

		subject(:execute_transfer) { described_class.new(source_account, destination_account, 500).execute } 

		context 'when source account have balance' do
			let!(:transaction) do
				FactoryBot.create(:financial_transaction, account: source_account, amount_cents: 1000)
			end

			it 'create transfer' do
				expect{ execute_transfer }.to change(Transfer, :count).by(1)
			end

			it 'debit from source account' do
				execute_transfer
				expect(source_account.balance_cents).to eq(500)
			end

			it 'credit from destination account' do
				execute_transfer
				expect(destination_account.balance_cents).to eq(500)
			end
		end

		context 'when source account do not have balance' do
			it 'raise NotEnoughAccountBalance' do
				expect{ execute_transfer }.to raise_exception(NotEnoughAccountBalance)
			end
		end

		context 'when have wrong params' do
			let!(:transaction) do
				FactoryBot.create(:financial_transaction, account: source_account, amount_cents: 1000)
			end

			it 'same account raise ActiveRecord::RecordInvalid' do
				expect do
				 described_class.new(source_account, source_account, 500).execute
				end.to raise_exception(ActiveRecord::RecordInvalid)
			end
		end
	end
end