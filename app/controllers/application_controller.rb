class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # After sign out, redirect to the sign-in page to avoid hitting
  # authenticated-only pages (which would set an unauthenticated flash).
  def after_sign_out_path_for(_resource_or_scope)
    # remove any flash set by Devise (e.g. signed_out) so translation-missing
    # messages are not shown after redirect
    flash.clear
    new_user_session_path
  end

  private

  def record_not_found
    render file: "#{Rails.root}/public/404.html", layout: true, status: :not_found
  end
end
