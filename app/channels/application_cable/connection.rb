module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      auth_token = request.params[:token]
      return reject_unauthorized_connection unless auth_token

      begin
        decoded = decode_token(auth_token)
        User.find(decoded[:user_id])
      rescue ActiveRecord::RecordNotFound, JWT::DecodeError
        reject_unauthorized_connection
      end
    end

    def decode_token(token)
      decoded = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      HashWithIndifferentAccess.new decoded
    end
  end
end
