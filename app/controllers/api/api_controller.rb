module Api
  class ApiController < ApplicationController
    skip_before_filter :verify_authenticity_token
    protect_from_forgery with: :null_session
    before_filter :authenticate

    def current_user
      @current_user
    end

    def authenticate
      authenticate_or_request_with_http_basic do |email, password|
        Rails.logger.info "API authentication:#{email} #{{password}}"
        user = User.find_by(email: email)
        if user && user.authenticate(password)
          @current_user = user
          Rails.logger.info "logging in #{user.inspect}"
          true
        else
          Rails.logger.warn "No valid credentials"
          false
        end
      end
    end
  end
end
