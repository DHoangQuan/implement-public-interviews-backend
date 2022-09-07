# frozen_string_literal: true

RSpec.describe 'api/v1/histories_controller', type: :request do
  let!(:account) { create(:account) }
  let!(:account_wallet) { create(:wallet, account: account, balance_cents: 100) }
  describe 'PUT #withdraw' do
    context 'valid params' do
      it 'should return new balance = old balance + input' do
        params = {
          balance: 100
        }
        put "/api/v1/accounts/#{account.id}/withdraw", params: params, as: :json

        body = JSON.parse(response.body).deep_symbolize_keys
        expect(body).to a_kind_of(Hash)
        expect(body[:data]).to a_kind_of(Hash)

        data = body[:data][:attributes]
        expect(data[:new_balance]).to eql(Money.new(account.wallet.balance_cents + params[:balance]).format)
      end
    end

    context 'invalid params' do
      it 'should return error with code 400' do
        params = {
          balance: -100
        }
        put "/api/v1/accounts/#{account.id}/withdraw", params: params, as: :json

        body = JSON.parse(response.body).deep_symbolize_keys
        expect(body[:status]).to eql(400)
      end
    end
  end

  describe 'PUT #deposit' do
    context 'valid params' do
      it 'should return new balance = old balance + input' do
        params = {
          balance: 100
        }
        put "/api/v1/accounts/#{account.id}/deposit", params: params, as: :json

        body = JSON.parse(response.body).deep_symbolize_keys
        expect(body).to a_kind_of(Hash)
        expect(body[:data]).to a_kind_of(Hash)

        data = body[:data][:attributes]
        expect(data[:new_balance]).to eql(Money.new(account.wallet.balance_cents - params[:balance]).format)
      end
    end

    context 'invalid account id' do
      it 'should return error with code 400' do
        params = {
          balance: -100
        }
        put "/api/v1/accounts/#{account.id}/deposit", params: params, as: :json

        body = JSON.parse(response.body).deep_symbolize_keys
        expect(body[:status]).to eql(400)
      end
    end
  end
end
