# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  let(:other_user) { create(:user) }
  let(:other_question) { create(:question, user: other_user) }

  let!(:link) { create(:link, linkable: question) }
  let!(:other_link) { create(:link, linkable: other_question) }

  it 'Unauthenticated user tries deletes link' do
    expect { delete :destroy, params: { id: link.id }, format: :js }.not_to change(Link, :count)
  end

  context 'Authenticated user tries' do
    before { login user }

    it 'delete link from his question' do
      expect { delete :destroy, params: { id: link.id }, format: :js }.to change(question.links, :count).by(-1)
    end

    it 'delete link from not his question' do
      expect { delete :destroy, params: { id: other_link.id }, format: :js }.not_to change(Link, :count)
    end

    it_behaves_like 'Render destroy template' do
      let(:params) { { id: link.id } }
    end
  end
end