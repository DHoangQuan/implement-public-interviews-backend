# frozen_string_literal: true

class BalanceSerializer
  include FastJsonapi::ObjectSerializer

  attribute :new_balance do |object|
    object&.wallet&.balance&.format
  end
end
