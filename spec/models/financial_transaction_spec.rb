require_relative '../spec_helper.rb'

describe FinancialTransaction do
	describe '#validations' do
		let(:resource) { FactoryBot.build(:financial_transaction) }

		shared_examples 'must be present' do |field|
			it "validate #{field} presence" do
				resource.send("#{field}=", nil)
				resource.valid?
				expect(resource.errors.messages).to eq({field.to_sym => ["can't be blank"]})
			end
		end

		include_examples 'must be present', 'currency'
		include_examples 'must be present', 'account'

		it 'validate amount greater then 0' do
			resource.kind = FinancialTransaction::KINDS[:debit]
			resource.amount = 1
			resource.valid?
			expect(resource.errors.messages[:amount]).to eq(["must be less than 0"])
		end

		it 'validate amount less then 0' do
			resource.kind = FinancialTransaction::KINDS[:credit]
			resource.amount = -1
			resource.valid?
			expect(resource.errors.messages[:amount]).to eq(["must be greater than 0"])
		end
	end	
end