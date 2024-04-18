class ApplicationController < ActionController::API
  MAX_PER_PAGE = 50
  
  # Method to apply pagination logic
  def apply_pagination(collection)
    per_page = params[:per_page].to_i

    per_page = MAX_PER_PAGE if per_page > MAX_PER_PAGE || per_page <= 0

    collection.page(params[:page]).per(per_page)
  end
end
