require_relative '../config/environment'

5.times do |i|
	puts 'Create user'
	user = User.create(username: "user-#{i}", password: '12345')
	puts "User created: #{user.id}"

	puts "Create account"
	account = Account.create(user: user, number: "num-#{i}")
	puts "Account created: #{account.id}"

	puts "Create Financial transaction"
	balance = FinancialTransaction.create(account: user.account, amount_cents: '100', 
																					kind: 'credit', currency: 'BRL')
	puts "Balance added: #{balance.amount_cents}"
end