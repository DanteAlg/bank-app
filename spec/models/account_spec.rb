require_relative '../spec_helper.rb'

describe Account do
	describe '#validations' do
		let(:resource) { FactoryBot.build(:account) }

		shared_examples 'must be present' do |field|
			it "validate #{field} presence" do
				resource.send("#{field}=", nil)
				resource.valid?
				expect(resource.errors.messages).to eq({field.to_sym => ["can't be blank"]})
			end
		end

		include_examples 'must be present', 'user'
		include_examples 'must be present', 'number'
	end
end