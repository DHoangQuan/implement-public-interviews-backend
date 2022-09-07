# frozen_string_literal: true

module WalletOperations
  # rubocop:disable Style/Documentation
  class Withdraw < ApplicationOperation
    def initialize(params)
      super()
      @params = params
    end

    def execute
      return render_error(404, 'Not Found', 'Not Found Account') unless account.present?

      valid_balance = @params[:balance].present? && @params[:balance].is_a?(Integer) && @params[:balance].positive?
      return render_error(400, 'Bad Request', 'Balance must be float and positive') unless valid_balance

      { status: 200, account: account } if update_balance == true
    rescue StandardError, AnotherError => e
      title = 'Withdraw Failed'
      render_error(400, title, e) and return
    end

    private

    def account
      Account.find_by_id(@params[:account_id])
    end

    def update_balance
      money = account.wallet

      money.update!(balance_cents: money.balance_cents + @params[:balance])
    end
  end
  # rubocop:enable Style/Documentation
end
