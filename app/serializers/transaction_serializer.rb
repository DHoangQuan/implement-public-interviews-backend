# frozen_string_literal: true

class TransactionSerializer
  include FastJsonapi::ObjectSerializer

  attributes :status, :created_at

  attribute :sender do |object|
    "#{object.sender.first_name} #{object.sender.last_name}"
  end

  attribute :reciever do |object|
    "#{object.reciever.first_name} #{object.reciever.last_name}"
  end

  attribute :transfer_balance do |object|
    object.transfer_balance.format
  end
end
