class SearchesController < ApplicationController
  def index
    @query = params[:query]
    @results = User.where("username ILIKE ?", "%#{@query}%") if @query.present?

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
