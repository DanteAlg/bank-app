require_relative '../spec_helper.rb'

describe Transfer do
	describe '#validations' do
		let(:resource) { FactoryBot.build(:transfer) }

		shared_examples 'must be present' do |field|
			it "validate #{field} presence" do
				resource.send("#{field}=", nil)
				resource.valid?
				expect(resource.errors.messages[field.to_sym]).to eq(["can't be blank"])
			end
		end

		include_examples 'must be present', 'source_account'
		include_examples 'must be present', 'destination_account'
		include_examples 'must be present', 'amount'
		include_examples 'must be present', 'currency'

		describe '#diferent_accounts_transfer' do
			let(:account) { FactoryBot.create(:account) }

			it 'must have diferent accounts in sourd and destination' do
				resource.source_account = resource.destination_account = account
				resource.valid?
				expect(resource.errors.messages).to eq({base: ['The transfer must be made to different accounts']})
			end
		end
	end
end