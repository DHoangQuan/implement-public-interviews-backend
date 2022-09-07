# frozen_string_literal: true

module AccountOperations
  # rubocop:disable Style/Documentation
  class Unverified < ApplicationOperation
    def initialize(params)
      super()
      @params = params
    end

    def execute
      return render_error(404, 'Not Found', 'Not Found Account') unless account.present?

      rs = update_account

      account if rs == true
    rescue StandardError, AnotherError => e
      title = 'Update Failed'
      render_error(400, title, e) and return
    end

    private

    def update_account
      account.update!(
        status: Account.statuses[:unverified]
      )
    end

    def account
      Account.find_by_id(@params[:id])
    end
  end
  # rubocop:enable Style/Documentation
end
