# frozen_string_literal: true

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
class Wallet < ApplicationRecord
  monetize :balance_cents, allow_nil: true

  belongs_to :account
end
