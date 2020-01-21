require 'sinatra/contrib'

module API
	class AccountsController < ApplicationController
		register Sinatra::Namespace

		before do
		  content_type 'application/json'
		end

		use Rack::Auth::Basic, "Protected Area" do |username, password|
		  user = User.find_by(username: username)
		  password == user.password
		end

		namespace '/api', provides: [:json] do
			get '/accounts/:id/balance' do
				account = Account.find(params[:id])
				json({ balance: account.balance })
			rescue ActiveRecord::RecordNotFound
				render_missing_account
			end

			post '/accounts/:id/transfer/:destination_id' do
				source_account = Account.find(params[:id])
				destination_account = Account.find(params[:destination_id])

				AccountTransfer.new(source_account, destination_account, params[:amount].to_i).execute
			rescue ActiveRecord::RecordNotFound
				render_missing_account
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