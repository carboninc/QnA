module SphinxHelpers
  def do_search_request(options = {})
    get :index, params: { search_text: 'some text' }.merge(options)
  end
end
