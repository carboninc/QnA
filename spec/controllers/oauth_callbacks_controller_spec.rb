# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'Github' do
    let(:oauth_data) { { provider: 'github', uid: 123 } }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exist' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it_behaves_like 'Login user'

      it_behaves_like 'Redirect to root path'
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it_behaves_like 'Redirect to root path'

      it_behaves_like 'Does not login user'
    end
  end

  describe 'Vkontakte' do
    let(:oauth_data) { { provider: 'vkontakte', uid: 123 } }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :vkontakte
    end

    context 'user exist' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :vkontakte
      end

      it_behaves_like 'Login user'

      it_behaves_like 'Redirect to root path'
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :vkontakte
      end

      it_behaves_like 'Redirect to root path'

      it_behaves_like 'Does not login user'
    end
  end
end
