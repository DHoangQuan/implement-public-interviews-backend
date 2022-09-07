# frozen_string_literal: true

# == Schema Information
#
# Table name: histories
#
#  id                        :bigint           not null, primary key
#  status                    :integer          default("pending"), not null
#  transfer_balance_cents    :integer          default(0), not null
#  transfer_balance_currency :string           default("USD"), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  reciever_id               :bigint           not null
#  sender_id                 :bigint           not null
#
# Indexes
#
#  index_histories_on_sender_id_and_reciever_id  (sender_id,reciever_id)
#
class History < ApplicationRecord
  monetize :transfer_balance_cents, allow_nil: true

  belongs_to :sender, class_name: 'Account'
  belongs_to :reciever, class_name: 'Account'

  enum status: {
    pending: 0,
    succeed: 1,
    failed: 2
  }, _suffix: true

  STATUS = {
    pending: 'pending',
    succeed: 'succeed',
    failed: 'failed'
  }.freeze
end
