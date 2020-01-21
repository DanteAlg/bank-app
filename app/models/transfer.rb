class Transfer < ActiveRecord::Base
  belongs_to :source_account, class_name: 'Account'
  belongs_to :destination_account, class_name: 'Account'

  validate :diferent_accounts_transfer
  validates_presence_of :source_account, :destination_account, :amount_cents, :currency

  def diferent_accounts_transfer
    return if source_account_id != destination_account_id

    errors.add(:base, 'The transfer must be made to different accounts')
  end
end
