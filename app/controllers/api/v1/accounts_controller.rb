# frozen_string_literal: true

module Api
  module V1
    # account controller
    class AccountsController < ApplicationController
      def index
        rs = AccountOperations::Index.new(params).execute

        render json: AccountSerializer.new(rs[:accounts]).serialized_json, status: 200
      rescue StandardError, AnotherError => e
        title = 'Bad Request'
        render_error(400, title, e) and return
      end

      def create
        rs = AccountOperations::Create.new(params).execute

        return render json: AccountSerializer.new(rs[:account]).serialized_json if rs[:status] == 200

        render json: rs
      rescue StandardError, AnotherError => e
        title = 'Bad Request'
        render_error(400, title, e) and return
      end

      def verified
        rs = AccountOperations::Verified.new(params).execute

        return render json: rs if rs[:status] == 404

        render json: {
          status: 200,
          message: 'Account is Verified'
        }
      rescue StandardError, AnotherError => e
        title = 'Bad Request'
        render_error(400, title, e) and return
      end

      def unverified
        rs = AccountOperations::Unverified.new(params).execute

        return render json: rs if rs[:status] == 404

        render json: {
          status: 200,
          message: 'Account is Unverified'
        }
      rescue StandardError, AnotherError => e
        title = 'Bad Request'
        render_error(400, title, e) and return
      end
    end
  end
end
