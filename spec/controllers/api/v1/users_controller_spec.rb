require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  context 'integrated' do
    let!(:application) { Doorkeeper::Application.create!(:name => "MyApp", :redirect_uri => "https://app.com") }
    let!(:user) { create :user }
    let!(:token) { Doorkeeper::AccessToken.create! :application_id => application.id, :resource_owner_id => user.id }

    describe 'GET index' do
      it 'responds with 200 and success' do
        get :index, format: :json, access_token: token.token
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it 'returns the user as json' do
        get :index, format: :json, access_token: token.token
        expect(response.body).to eq(user.to_json)
      end
    end

    describe 'PUT #update' do
      context 'with valid attributes' do
        it 'responds with 200 and success' do
          put :update, format: :json, goal: 300, access_token: token.token, id: user.id
          expect(response).to be_success
          expect(response.status).to eq(200)
        end

        it 'returns the user as json' do
          put :update, format: :json, goal: 300, access_token: token.token, id: user.id
          user.reload
          expect(response.body).to eq(user.to_json)
        end

        it 'modifies the goal' do
          put :update, format: :json, goal: 300, access_token: token.token, id: user.id
          user.reload
          expect(user.goal).to eq(300)
        end
      end

      context 'with invalid attributes' do
        it 'responds with 422' do
          put :update, format: :json, goal: -200, access_token: token.token, id: user.id
          expect(response.status).to eq(422)
        end

        it 'does not modify the user' do
          put :update, format: :json, goal: -200, access_token: token.token, id: user.id
          user.reload
          expect(user.goal).not_to eq(-200)
        end
      end
    end
  end
  context 'not integrated' do
    describe 'POST #create user' do
      context 'with valid attributes' do
        it 'responds with 201 and success' do
          post :create, email: 'renly@barathe.on', password: 'test1234'
          expect(response).to be_success
          expect(response.status).to eq(201)
        end

        it 'increases the number of users by one' do
          expect do
            post :create, email: 'renly@barathe.on', password: 'test1234'
          end.to change(User, :count).by(1)
        end
      end
      context 'with invalid attributes' do
        it 'responds with 422' do
          post :create, email: 'arya@sta.rk'
          expect(response.status).to eq(422)
        end

        it 'does not change the number of users' do
          expect do
            post :create, email: 'arya@sta.rk'
          end.not_to change(User, :count)
        end
      end
    end
  end
end
