require 'rails_helper'

RSpec.describe Api::V1::EntriesController, type: :controller do
  context 'integrated' do
    let!(:application) { Doorkeeper::Application.create!(:name => "MyApp", :redirect_uri => "https://app.com") }
    let!(:user) { create :user }
    let!(:token) { Doorkeeper::AccessToken.create! :application_id => application.id, :resource_owner_id => user.id }

    describe 'GET #index' do
      context 'without parameters' do
        before :each do
          @e1, @e2, @e3 = create(:entry, user_id: user.id),
                          create(:entry, user_id: user.id),
                          create(:entry, user_id: user.id)
          @other_user = create :user_with_entries
        end
        it 'responds with 200 and success' do
          get :index, format: :json, access_token: token.token
          expect(response).to be_success
          expect(response.status).to eq(200)
        end

        it 'assigns the latest entries for user' do
          get :index, format: :json, access_token: token.token
          expect(assigns(:entries)).to match_array [@e1, @e2, @e3]
        end

        it 'does not contain other users entries' do
          get :index, format: :json, access_token: token.token
          expect(assigns(:entries)).not_to include @other_user.entries
        end
      end
      context 'with parameters' do
        before :each do
          @e1, @e2, @e3 = create(:entry, user_id: user.id, entry_time: 3000),
                          create(:entry, user_id: user.id, entry_time: 4000),
                          create(:entry, user_id: user.id, entry_time: 5000)
        end
        it 'responds with 200 and success' do
          get :index, format: :json, access_token: token.token, from_time: 3500, to_time: 4500
          expect(response).to be_success
          expect(response.status).to eq(200)
        end

        it 'assigns the latest entries within range' do
          get :index, format: :json, access_token: token.token, from_time: 3500, to_time: 4500
          expect(assigns(:entries)).to match_array [@e2]
        end

        it 'does not contain entries out of range' do
          get :index, format: :json, access_token: token.token, from_time: 3500, to_time: 4500
          expect(assigns(:entries)).not_to include [@e1, @e3]
        end
      end
    end

    describe 'POST #create' do
      context 'with valid parameters' do
        pending 'responds with 200 and success'
        pending 'increases entries count by one'
      end
      context 'with invalid parameters' do
        pending 'responds with 422'
        pending 'does not change entries count'
      end
    end

    describe 'PUT #update' do
      pending 'same as above'
    end

    describe 'DELETE #destroy' do
      before :each do
        @entry = create(:entry, user_id: user.id)
      end

      it 'responds with 200 and success' do
        delete :destroy, format: :json, access_token: token.token, id: @entry.id
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it 'decreases the entry count by one' do
        expect do
          delete :destroy, format: :json, access_token: token.token, id: @entry.id
        end.to change(Entry, :count).by(-1)
      end
    end
  end
end
