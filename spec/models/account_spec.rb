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
require 'rails_helper'

RSpec.describe Account, type: :model do
  subject(:account) { build(:account) }

  it 'has a valid factory' do
    expect(account).to be_valid
  end

  describe 'Associations' do
    it { is_expected.to have_many(:sender_histories).with_foreign_key(:sender_id).class_name('History') }
    it { is_expected.to have_many(:senders).through(:sender_histories).class_name('Account') }
    it { is_expected.to have_many(:reciever_histories).with_foreign_key(:reciever_id).class_name('History') }
    it { is_expected.to have_many(:recievers).through(:reciever_histories).class_name('Account') }
    it { is_expected.to have_one(:wallet) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:phone_number) }
    it { is_expected.to validate_presence_of(:email) }
  end
end
