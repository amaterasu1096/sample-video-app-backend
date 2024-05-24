module Api
  module V1
    class AuthenticationController < BaseController
      def authenticate
        user = User.find_by(email: user_params[:email])

        if user
          if user.authenticate(user_params[:password])
            render json: { email: user.email, token: generate_token(user_id: user.id) }, status: :ok
          else
            render json: { error: 'Invalid password' }, status: :unauthorized
          end
        else
          user = User.new(user_params)
          if user.save
            render json: { email: user.email, token: generate_token(user_id: user.id) }, status: :created
          else
            render json: { error: user.errors.full_messages.join('. ') }, status: :unprocessable_entity
          end
        end
      end

      private

      def user_params
        params.permit(:email, :password)
      end

      def generate_token(payload)
        exp = 24.hours.from_now.to_i
        payload[:exp] = exp
        JWT.encode(payload, Rails.application.secrets.secret_key_base)
      end
    end
  end
end
