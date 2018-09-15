class SearchController < ApplicationController
  before_action :authenticate_request!

=begin
  Original Author: Sapna Mishra
  Desc: Search data from any model
  Module Creation Date: 13-09-2018 
  Request Parameter: search*
  Response Parameter: code, message,data
  Http Method : GET
  URL: HOSTNAME + /search
=end

  def search_data
    if params[:search].blank?
      render_error("Please enter value for search field")
      return
    end

    #search data from any model
    search_result = SearchService.search_from_models(params[:search])

    render_success("Search result found successfully.",search_result)
  end

end