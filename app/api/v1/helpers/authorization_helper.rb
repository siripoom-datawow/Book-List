# frozen_string_literal: true

module V1
  module Helpers
    module AuthorizationHelper
      extend Grape::API::Helpers

      def authenticate!
          token = headers['authorization'].to_s.split(' ')[1]
          return error!('Token not founded', 401) unless token.present?

          user = User.find_by(auth_token: token)
          return error!('Invalid token', 401) unless user.present?

          @user = user
      end
    end
  end
end
