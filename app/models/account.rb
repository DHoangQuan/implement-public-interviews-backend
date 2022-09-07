# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id           :bigint           not null, primary key
#  email        :string
#  first_name   :string
#  last_name    :string
#  phone_number :string
#  status       :integer          default("pending"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_accounts_on_email         (email)
#  index_accounts_on_phone_number  (phone_number)
#  index_accounts_on_status        (status)
#
class Account < ApplicationRecord
  # sender
  has_many :sender_histories, foreign_key: :sender_id, class_name: 'History'
  has_many :senders, through: :sender_histories, class_name: 'Account'

  # reciever
  has_many :reciever_histories, foreign_key: :reciever_id, class_name: 'History'
  has_many :recievers, through: :reciever_histories, class_name: 'Account'

  has_one :wallet

  validates :first_name, :last_name, :email, :phone_number, presence: true
  validates :email, uniqueness: true, on: :create

  enum status: {
    unverified: -1,
    pending: 0,
    verified: 1
  }, _suffix: true

  STATUS = {
    unverified: 'unverified',
    pending: 'pending',
    verified: 'verified'
  }.freeze
end
