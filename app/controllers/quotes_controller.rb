class QuotesController < ApplicationController
  before_action :authorize_request
  
  # GET /quotes/{search_tag}
  def search_tag
    @quotes = QuoteService.new(params[:search_tag]).execute
    @quotes.present? ? (render json: @quotes) : (render json: { error: "Tag não existe" } )
  end

  private
  
  def quote_params
    params.require(:quote).permit(:quote, :author_id)
  end
end
