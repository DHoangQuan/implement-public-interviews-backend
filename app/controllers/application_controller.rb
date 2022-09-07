# frozen_string_literal: true

class ApplicationController < ActionController::API
  private

  def render_error(status, title, message)
    error_hash = {
      errors: [
        status: status,
        title: title,
        detail: message
      ]
    }
    render json: error_hash, status: status
  end
end
