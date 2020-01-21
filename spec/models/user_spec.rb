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
end