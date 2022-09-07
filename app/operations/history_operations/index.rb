# frozen_string_literal: true

module HistoryOperations
  # rubocop:disable Style/Documentation
  class Index < ApplicationOperation
    def initialize(params)
      super()
      @params = params
    end

    def execute
      return render_error(404, 'Not Found', 'User Not Found') unless account.present?

      transactions = History.where(sender_id: account.id)
                            .or(History.where(sender_id: account.id))
                            .order(created_at: :DESC)
                            .paginate(page: @params[:page], per_page: 10)

      { status: 200, transactions: transactions }
    rescue StandardError, AnotherError => e
      title = 'Bad Request'
      render_error(400, title, e) and return
    end

    private

    def account
      Account.find_by_id(@params[:account_id])
    end
  end
  # rubocop:enable Style/Documentation
end
