# == Schema Information
#
# Table name: wallets
#
#  id               :bigint           not null, primary key
#  balance_cents    :integer          default(0), not null
#  balance_currency :string           default("USD"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  account_id       :bigint           not null
#
# Indexes
#
#  index_wallets_on_account_id  (account_id)
#
require 'rails_helper'

RSpec.describe Wallet, type: :model do
  subject(:wallet) { build(:wallet) }

  it 'has a valid history' do
    expect(wallet).to be_valid
  end
end
