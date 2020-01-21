# Bank App

Simple [corneal](https://github.com/thebrianemory/corneal) app to make transfers between accounts and show balance.

* MVC structure
* [Sinatra](https://github.com/sinatra/sinatra)
* Rspec

## Setup application

- Execute `$ cp config/database.yml.example config/database.yml` and config keys to your postgresql database
- Run `$ rake db:create` and `rake db:migrate` to create and build database
- Run `$ shotgun` to start application server

## Console

Run `$ tux` to interact with your application in console


## Tests

`$ rspec`

## Routes 

* Autenticação via basic (username, password)
* Rota para visualizar saldo de uma conta `/api/accounts/:id/balance` 
* Rota para transferir dinheiro para outra conta `/api/accounts/:id/transfer/:destination_id` 

