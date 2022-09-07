# frozen_string_literal: true

module Api
  module V1
    class WalletsController < ApplicationController
      def withdraw
        rs = WalletOperations::Withdraw.new(params).execute

        return render json: BalanceSerializer.new(rs[:account]).serialized_json if rs[:status] == 200

        render json: rs
      rescue StandardError, AnotherError => e
        title = 'Bad Request'
        render_error(400, title, e) and return
      end

      def deposit
        rs = WalletOperations::Deposit.new(params).execute

        return render json: BalanceSerializer.new(rs[:account]).serialized_json if rs[:status] == 200

        render json: rs
      rescue StandardError, AnotherError => e
        title = 'Bad Request'
        render_error(400, title, e) and return
      end
    end
  end
end
