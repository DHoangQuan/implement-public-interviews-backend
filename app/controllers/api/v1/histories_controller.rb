# frozen_string_literal: true

module Api
  module V1
    class HistoriesController < ApplicationController
      def index
        rs = HistoryOperations::Index.new(params).execute

        if rs[:status] == 200
          return render json: TransactionSerializer.new(rs[:transactions]).serialized_json, status: 200
        end

        render json: rs
      rescue StandardError, AnotherError => e
        title = 'Load History Failed'
        render_error(400, title, e) and return
      end

      def transfer_balance
        rs = HistoryOperations::TransferMoney.new(params).execute

        if rs[:status] == 200
          return render json: TransactionSerializer.new(rs[:transaction]).serialized_json, status: 200
        end

        render json: rs
      rescue StandardError, AnotherError => e
        title = 'Failed Transaction'
        render_error(400, title, e) and return
      end
    end
  end
end
