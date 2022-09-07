# frozen_string_literal: true

module AccountOperations
  # rubocop:disable Style/Documentation
  class Index < ApplicationOperation

    def initialize(params)
      super()
      @params = params
    end

    def execute
      accounts = Account.all.paginate(page: @params[:page], per_page: 10)

      { status: 200, accounts: accounts }
    rescue StandardError, AnotherError => e
      title = 'Load Fail'
      render_error(400, title, e) and return
    end
  end
  # rubocop:enable Style/Documentation
end
