# frozen_string_literal: true

# ------------------------------------------------
class SearchController < ApplicationController
  skip_authorization_check

  def index
    search_text = params[:search_text]
    search_object = params[:search_object]

    if search_text.empty?
      redirect_back(fallback_location: root_path)
      flash[:notice] = 'You did not enter anything in the search bar'
    else
      @search_results = Search.search_results(search_text, search_object)
    end
  end
end
