# frozen_string_literal: true

RSpec.describe 'api/v1/histories_controller', type: :request do
  let!(:sender) { create(:account) }
  let!(:sender_wallet) { create(:wallet, account: sender, balance_cents: 1100) }
  let!(:reciever) { create(:account) }
  let!(:reciever_wallet) { create(:wallet, account: reciever) }

  describe 'GET #index' do
    context 'valid sender id' do
      subject { get "/api/v1/accounts/#{sender.id}/history" }

      it 'should return list transaction of sender' do
        11.times do
          create(:history, sender: sender, reciever: reciever, transfer_balance_cents: 100)
        end
        subject

        body = JSON.parse(response.body).deep_symbolize_keys
        expect(body[:data]).to be_an_instance_of(Array)
        expect(body[:data].count).to eql(10)
      end
    end

    context 'invalid sender id' do
      subject { get "/api/v1/accounts/#{sender.id + 999_999}/history" }

      it 'should return list transaction of sender' do
        create(:history, sender: sender, reciever: reciever, transfer_balance_cents: 100)
        subject

        body = JSON.parse(response.body).deep_symbolize_keys
        expect(body[:status]).to eql(404)
      end
    end
  end

  describe 'POST #transfer_balance' do
    context 'transfer with account status not verified' do
      subject { post "/api/v1/accounts/#{sender.id}/transfer", params: params }
      let!(:params) do
        {
          recieverId: reciever.id,
          transferBalance: 100
        }
      end
      it 'should return transaction with sender and reciever name' do
        subject

        body = JSON.parse(response.body).deep_symbolize_keys
        expect(body[:status]).to eql(403)
      end
    end

    context 'transfer with invalid params' do
      subject { post "/api/v1/accounts/#{sender.id}/transfer", params: params }
      let!(:params) do
        {
          recieverId: reciever.id
        }
      end

      it 'should return 400 bad request' do
        subject

        body = JSON.parse(response.body).deep_symbolize_keys
        expect(body[:status]).to eql(400)
      end
    end

    context 'transfer with invalid params' do
      before(:each) do
        sender.update(status: Account.statuses[:verified])
        reciever.update(status: Account.statuses[:verified])
      end
      it 'should return succeed transaction which sent by id' do
        params = {
          recieverId: reciever.id,
          transferBalance: 100
        }
        post "/api/v1/accounts/#{sender.id}/transfer", params: params, as: :json

        body = JSON.parse(response.body).deep_symbolize_keys
        expect(body).to a_kind_of(Hash)
        expect(body[:data]).to a_kind_of(Hash)

        data = body[:data][:attributes]
        expect(data[:status]).to eql(History::STATUS[:succeed])
        expect(data[:sender]).to eql("#{sender.first_name} #{sender.last_name}")
        expect(data[:reciever]).to eql("#{reciever.first_name} #{reciever.last_name}")
        expect(data[:transfer_balance]).to eql(Money.new(params[:transferBalance]).format)
      end

      it 'should return succeed transaction which sent by email' do
        params = {
          recieverEmail: reciever.email,
          transferBalance: 50
        }
        post "/api/v1/accounts/#{sender.id}/transfer", params: params, as: :json

        body = JSON.parse(response.body).deep_symbolize_keys
        expect(body).to a_kind_of(Hash)
        expect(body[:data]).to a_kind_of(Hash)

        data = body[:data][:attributes]
        expect(data[:status]).to eql(History::STATUS[:succeed])
        expect(data[:sender]).to eql("#{sender.first_name} #{sender.last_name}")
        expect(data[:reciever]).to eql("#{reciever.first_name} #{reciever.last_name}")
        expect(data[:transfer_balance]).to eql(Money.new(params[:transferBalance]).format)
      end

      it 'should return succeed transaction which sent by phone number' do
        params = {
          recieverPhone: reciever.phone_number,
          transferBalance: 50
        }
        post "/api/v1/accounts/#{sender.id}/transfer", params: params, as: :json

        body = JSON.parse(response.body).deep_symbolize_keys
        expect(body).to a_kind_of(Hash)
        expect(body[:data]).to a_kind_of(Hash)

        data = body[:data][:attributes]
        expect(data[:status]).to eql(History::STATUS[:succeed])
        expect(data[:sender]).to eql("#{sender.first_name} #{sender.last_name}")
        expect(data[:reciever]).to eql("#{reciever.first_name} #{reciever.last_name}")
        expect(data[:transfer_balance]).to eql(Money.new(params[:transferBalance]).format)
      end
    end
  end
end
