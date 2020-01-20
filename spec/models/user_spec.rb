require_relative '../spec_helper.rb'

describe User do
	describe '#validations' do
		let(:user) { FactoryBot.build(:user) }

		describe 'username uniqueness' do
			before { FactoryBot.create(:user, username: 'foo') }
			
			it 'must invalidate the user' do	
				user.username = 'foo'
				user.valid?
				expect(user.errors.messages).to eq({ username: ['has already been taken']})
			end
		end
	end

	describe '#password=' do
		let(:user) { FactoryBot.build(:user) }

		it 'must fill password_digest' do
			expect { user.password = 'foobar' }.to change{ user.password_digest }
		end
	end

	describe '#password' do
		let!(:user) { FactoryBot.create(:user, password_digest: BCrypt::Password.create('123456')) }

		it 'must match with password string' do
			expect(user.password).to eq('123456')
		end
	end
end