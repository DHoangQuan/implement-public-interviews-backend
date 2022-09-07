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
FactoryBot.define do
  factory :history do
    association :sender, factory: :account
    association :reciever, factory: :account

    transfer_balance_cents { 0 }
  end
end
