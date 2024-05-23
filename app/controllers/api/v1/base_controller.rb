module Api
  module V1
    class BaseController < ActionController::API
      rescue_from StandardError, with: :standard_error

      private

      def current_user
        @current_user ||= begin
          header = request.headers['Authorization']
          header = header.split(' ').last if header
          decoded = decode_token(header)
          User.find(decoded[:user_id]) if decoded
        rescue ActiveRecord::RecordNotFound, JWT::DecodeError
          nil
        end
      end

      def authenticate_user!
        render json: { error: 'Not Authorized' }, status: :unauthorized unless current_user
      end
    
      def decode_token(token)
        decoded = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
        HashWithIndifferentAccess.new decoded
      end

      def standard_error(exception)
        render json: { error: "An unexpected error occurred: #{exception.message}" }, status: :internal_server_error
      end
    end
  end
end
