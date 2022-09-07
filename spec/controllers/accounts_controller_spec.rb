# frozen_string_literal: true

RSpec.describe 'api/v1/accounts_controller', type: :request do
  require 'faker'

  describe 'GET #index' do
    subject { get '/api/v1/accounts' }

    it 'should return list account' do
      11.times do
        account = create(:account)
        create(:wallet, account: account)
      end
      subject

      body = JSON.parse(response.body).deep_symbolize_keys
      expect(body[:data]).to be_an_instance_of(Array)
      expect(body[:data].count).to eq 10
    end
  end

  describe 'POST #create' do
    context 'valid params' do
      init_balance = '$0.00'
      params = {
        firstName: Faker::Name.first_name,
        lastName: Faker::Name.last_name,
        email: Faker::Internet.email,
        phoneNumber: Faker::PhoneNumber.cell_phone_in_e164
      }
      subject { post '/api/v1/accounts', params: params }

      it 'should return info of created with balance = 0 object' do
        subject

        body = JSON.parse(response.body).deep_symbolize_keys
        expect(body[:data]).not_to be_empty

        data = body[:data][:attributes]
        expect(data[:first_name]).to eql(params[:firstName])
        expect(data[:last_name]).to eql(params[:lastName])
        expect(data[:email]).to eql(params[:email])
        expect(data[:phone_number]).to eql(params[:phoneNumber])
        expect(data[:status]).to eql(Account::STATUS[:pending])
        expect(data[:balance]).to eql(init_balance)
      end
    end

    context 'invalid params' do
      params = {
        firstName: '',
        lastName: '',
        email: '',
        phoneNumber: ''
      }
      subject { post '/api/v1/accounts', params: params }

      it 'should return error' do
        subject

        body = JSON.parse(response.body).deep_symbolize_keys
        expect(body[:status]).to eql(400)
      end
    end
  end

  describe 'PUT #verified and #unverified' do
    let!(:user) { create(:account) }
    context 'verified with valid params id' do
      let(:params) do
        {
          id: user.id
        }
      end
      subject { put '/api/v1/accounts/verified', params: params }
      it 'should return status 200' do
        subject
        body = JSON.parse(response.body).deep_symbolize_keys

        expect(body[:status]).to eql(200)
      end
    end

    context 'verified with invalid params id' do
      let(:params) do
        {
          id: user.id + 1
        }
      end
      subject { put '/api/v1/accounts/verified', params: params }
      it 'should return status 404' do
        subject

        body = JSON.parse(response.body).deep_symbolize_keys
        expect(body[:status]).to eql(404)
      end
    end

    context 'unverified with valid params id' do
      let(:params) do
        {
          id: user.id
        }
      end
      subject { put '/api/v1/accounts/unverified', params: params }
      it 'should return status 200' do
        subject
        body = JSON.parse(response.body).deep_symbolize_keys

        expect(body[:status]).to eql(200)
      end
    end

    context 'unverified with invalid params id' do
      let(:params) do
        {
          id: user.id + 1
        }
      end
      subject { put '/api/v1/accounts/unverified', params: params }
      it 'should return status 404' do
        subject

        body = JSON.parse(response.body).deep_symbolize_keys
        expect(body[:status]).to eql(404)
      end
    end
  end
end
