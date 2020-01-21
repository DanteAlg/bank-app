require 'sinatra/contrib'

module API
	class AccountsController < ApplicationController
		register Sinatra::Namespace

		before do
		  content_type 'application/json'
		end

		use Rack::Auth::Basic, "Protected Area" do |username, password|
		  user = User.find_by(username: username)
		  user.authenticate(password)
		end

		namespace '/api', provides: [:json] do
			get '/accounts/:id/balance' do
				account = Account.find(params[:id])
				json({ balance: "R$ #{account.balance_cents.to_f/100}" })
			rescue ActiveRecord::RecordNotFound
				render_missing_account
			end

			post '/accounts/:id/transfer/:destination_id' do
				source_account = Account.find(params[:id])
				destination_account = Account.find(params[:destination_id])
				parsed_body =  JSON.parse(request.body.read)

				transfer = AccountTransfer.new(source_account, destination_account, parsed_body['amount'].to_i).execute

				json(transfer)
			rescue ActiveRecord::RecordNotFound
				render_missing_account
			rescue ActiveRecord::RecordInvalid => e
				status 422
				json({ error: e.message })
			rescue NotEnoughAccountBalance
				status 422
				json({ error: 'Insufficient bank balance' })
			end
		end

		private

		def render_missing_account
			status 404
			json({ error: 'Not found' })
		end
	end
end