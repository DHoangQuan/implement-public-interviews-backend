# frozen_string_literal: true

module HistoryOperations
  # rubocop:disable Style/Documentation
  class TransferMoney < ApplicationOperation
    def initialize(params)
      super()
      @params = params
    end

    def execute
      rs = transfer_history
      transaction_id = rs[:id]
      return rs if rs[:status] != History::STATUS[:pending]

      rs = valid_balance
      return rs if rs[:status] != 200

      transaction = History.find(transaction_id)

      ActiveRecord::Base.transaction do
        transfer_amount
        update_status_succeed(transaction)
      end

      {
        status: 200,
        transaction: transaction.reload
      }
    rescue StandardError, AnotherError => e
      title = 'Failed Transaction'
      render_error(400, title, e) and return
    end

    private

    def sender
      Account.find_by_id(@params[:sender_id])
    end

    def reciever
      return Account.find_by_email(@params[:reciever_email]) if @params[:reciever_email].present?
      return Account.find_by_phone_number(@params[:reciever_phone]) if @params[:reciever_phone].present?

      Account.find_by_id(@params[:reciever_id])
    end

    def valid_balance
      valid_balance = @params[:transfer_balance].is_a?(Float) ||
                      @params[:transfer_balance].positive?

      unless valid_balance
        transfer_history.update!(status: History.statuses[:failed])
        return render_error(400, 'Bad Request', 'Balance must be number and positive')
      end

      sender_balance = sender&.wallet&.balance_cents

      valid_sender_balance = sender_balance.positive? && @params[:transfer_balance] <= sender_balance
      unless valid_sender_balance
        transfer_history.update!(status: History.statuses[:failed])
        return render_error(400, 'Lacking Balance', 'Sender Balance not enough')
      end

      { status: 200 }
    end

    def transfer_history
      return render_error(400, 'Bad Request', 'Transfer balance must exist') unless @params[:transfer_balance].present?
      return render_error(404, 'Not Found', 'User Not Found') unless sender.present? && reciever.present?
      return render_error(403, 'Forbidden', 'No Permission') unless valid_authorize
      return render_error(400, 'Bad Request', 'Reciever must not you') if sender.id == reciever.id

      History.create(
        sender_id: sender.id,
        reciever_id: reciever.id,
        transfer_balance_cents: @params[:transfer_balance],
        status: History.statuses[:pending]
      )
    end

    def transfer_amount
      sender_money = sender.wallet
      reciever_money = reciever.wallet

      sender_money.update!(balance_cents: sender_money.balance_cents - @params[:transfer_balance])
      reciever_money.update!(balance_cents: reciever_money.balance_cents + @params[:transfer_balance])
    end

    def update_status_succeed(transaction)
      transaction.update!(
        status: History.statuses[:succeed]
      )
    end

    def valid_authorize
      reciever.status == Account::STATUS[:verified] && sender.status == Account::STATUS[:verified]
    end
  end
  # rubocop:enable Style/Documentation
end
