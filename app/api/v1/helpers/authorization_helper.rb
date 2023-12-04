    module V1::Helpers
      module AuthorizationHelper
        extend Grape::API::Helpers

        def authenticate!
          Rails.cache.fetch("current_user", expires_in: 1.day) do
            token = headers['authorization'].to_s.split(' ')[1]
            return error!('Token not founded', 401) unless token.present?

            user = User.find_by(auth_token: token)
            return error!('Invalid token', 401) unless user.present?

            user.id
          end
        end
      end
    end
