# frozen_string_literal: true

class ApplicationOperation
  private

  def render_error(status, title, message)
    {
      status: status,
      errors: [
        title: title,
        detail: message
      ]
    }
  end
end
