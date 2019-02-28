# frozen_string_literal: true

require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { CONTENT_TYPE: 'application/json', ACCEPT: 'application/json' }
  end

  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }


  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/profiles/me' }
      let(:method) { :get }
    end

    context 'authorized' do
      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Response Successful'

      it_behaves_like 'Return public field' do
        let(:array) { %w[id email admin created_at updated_at] }
        let(:json_object) { json }
        let(:object) { me }
      end

      it_behaves_like 'Does not return private fields' do
        let(:array) { %w[password encrypted_password] }
        let(:json_object) { json }
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/profiles' }
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:profiles) { create_list(:user, 3) }
      let(:profile) { profiles.first }

      before { get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Response Successful'

      it_behaves_like 'Return list of object' do
        let(:object) { profiles }
        let(:count) { 3 }
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(profile[attr].as_json).to eq profile.send(attr).as_json
        end
      end

      it_behaves_like 'Does not return private fields' do
        let(:array) { %w[password encrypted_password] }
        let(:json_object) { json.first }
      end

      it 'not include me' do
        profiles.each do |profile|
          expect(profile).to_not eq me
        end
      end
    end
  end
end
