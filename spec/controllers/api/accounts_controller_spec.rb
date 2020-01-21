require_relative "../../spec_helper"

describe API::AccountsController, type: :controller do
	let(:json_response) { JSON.parse(last_response.body) }

	describe 'GET /api/accounts/:id/balance' do
		let!(:account) { FactoryBot.create(:account) }
		let(:user) { account.user }

		subject(:get_balance) { get("/api/accounts/#{account.id}/balance") }

		context 'when user is not logged' do
			it 'get unauthorized status' do
				get_balance
				expect(last_response.status).to eq(401)
			end
		end

		context 'when logged user' do
			let!(:transaction_1) do
				FactoryBot.create(:financial_transaction, account: account, amount_cents: 1000,
					kind: FinancialTransaction::KINDS[:credit])
			end
			let!(:transaction_2) do
				FactoryBot.create(:financial_transaction, account: account, amount_cents: -123,
					kind: FinancialTransaction::KINDS[:debit])
			end

			before { authorize(user.username, user.password) } 
 
			it 'get ok status' do
				get_balance
				expect(last_response.status).to eq(200)
			end

			it 'get balance' do
				get_balance
				expect(json_response['balance']).to eq("R$ 8.77")
			end

			context 'when account do not exist' do
				subject(:get_invalid_balance) { get("/api/accounts/foo/balance") }

				it 'get not found status' do
					get_invalid_balance
					expect(last_response.status).to eq(404)
				end

				it 'get not found status' do
					get_invalid_balance
					expect(json_response).to eq({ 'error' => 'Not found'})
				end
			end
		end
	end

	describe 'POST /api/accounts/:id/transfer/:destination_id' do
		let!(:source_account) { FactoryBot.create(:account) }
		let!(:destination_account) { FactoryBot.create(:account) }
		let(:user) { source_account.user }

		subject(:do_transfer) do
			post("/api/accounts/#{source_account.id}/transfer/#{destination_account.id}", 
				{ amount: 500 }.to_json, {'CONTENT_TYPE' => 'application/json'})
		end

		context 'when user is not logged' do
			it 'get unauthorized status' do
				do_transfer
				expect(last_response.status).to eq(401)
			end
		end

		context 'when logged user' do
			before { authorize(user.username, user.password) }

			describe 'with positive balance' do
				let!(:transaction_1) do
					FactoryBot.create(:financial_transaction, account: source_account, amount_cents: 1000,
						kind: FinancialTransaction::KINDS[:credit])
				end

				it 'create transfer' do
					expect{ do_transfer }.to change(Transfer, :count).by(1)
				end

				it 'create financial_transactions' do
					expect{ do_transfer }.to change(FinancialTransaction, :count).by(2)
				end

				it 'change source balance' do
					do_transfer
					expect(source_account.balance_cents).to eq(500)
				end

				it 'change destination balance' do
					do_transfer
					expect(destination_account.balance_cents).to eq(500)
				end
			end

			describe 'without account balance' do
				it 'not create transfer' do
					expect{ do_transfer }.to_not change(Transfer, :count)
				end

				it 'not create financial_transactions' do
					expect{ do_transfer }.to_not change(FinancialTransaction, :count)
				end

				it 'get Unprocessable Entity status' do
					do_transfer
					expect(last_response.status).to eq(422)
				end

				it 'get error in json' do
					do_transfer
					expect(json_response).to eq({ 'error' => 'Insufficient bank balance' })
				end
			end

			context 'when source or destination accounts not exists' do
				describe 'invalid source' do
					it 'render Not Found error' do
						post("/api/accounts/foo/transfer/#{destination_account.id}", amount: 500)
						expect(json_response).to eq({ 'error' => 'Not found' })
					end
				end

				describe 'invalid destination' do
					it 'render Not Found error' do
						post("/api/accounts/#{source_account.id}/transfer/bar", amount: 500)
						expect(json_response).to eq({ 'error' => 'Not found' })
					end
				end
			end
 		end
	end
end
