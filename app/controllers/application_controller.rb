class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_not_valid_response

  def render_not_found_response(exception)
    render json: { error: exception.message }, status: :not_found 
  end

  # def render_not_valid_response(exception)
  #   render json: { error: exception.message }, status: :bad_request
  # end
end
