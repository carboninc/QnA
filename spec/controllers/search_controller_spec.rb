require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    it 'returns 200 status code' do
      do_search_request(search_object: 'All')
      expect(response).to be_successful
    end

    %w[All Questions Answers Comments Users].each do |search_object|
      it "calls search for #{search_object}" do
        expect(Search).to receive(:search_results).with('some text', search_object)
        do_search_request(search_object: search_object)
      end
    end

    it 'renders index template' do
      do_search_request(search_object: 'All')
      expect(response).to render_template :index
    end

    it 'redirects to current page if query is empty' do
      do_search_request(search_text: '')
      expect(response).to redirect_to root_path
    end
  end
end
