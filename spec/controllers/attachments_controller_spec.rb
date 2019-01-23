# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    let(:other_user) { create(:user) }
    let(:other_question) { create(:question, user: other_user) }

    before do
      @file = question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
    end

    it 'Unauthenticated user tries delete attached file' do
      expect { delete :destroy, params: { id: @file[0].id }, format: :js }.not_to change(ActiveStorage::Attachment, :count)
    end

    context 'Authenticated user' do
      before { login user }

      it 'delete his attached file' do
        expect { delete :destroy, params: { id: @file[0].id }, format: :js }.to change(question.files, :count).by(-1)
      end

      it 'deletes not his attached file' do
        @other_file = other_question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
        expect { delete :destroy, params: { id: @other_file[0].id }, format: :js }.not_to change(ActiveStorage::Attachment, :count)
      end
    end
  end
end