# frozen_string_literal: true

module AccountOperations
  # rubocop:disable Style/Documentation
  class Create < ApplicationOperation
    def initialize(params)
      super()
      @params = params
    end

    # rubocop:disable Metrics/MethodLength
    def execute
      account = new_account

      return render_error(400, 'Bad Request', account.errors.objects.first.full_message) unless account.valid?

      ActiveRecord::Base.transaction do
        account.save
        account.reload
        create_wallet_balance(account)
      end

      { status: 200, account: account }
    rescue StandardError, AnotherError => e
      title = 'Create Failed'
      render_error(400, title, e) and return
    end
    # rubocop:enable Metrics/MethodLength

    private

    def new_account
      Account.new(
        first_name: @params[:first_name],
        last_name: @params[:last_name],
        phone_number: @params[:phone_number],
        email: @params[:email]
      )
    end

    def create_wallet_balance(account)
      account.create_wallet(balance: 0)
    end
  end
  # rubocop:enable Style/Documentation
end
