# frozen_string_literal: true

module V1
  class API < Grape::API
    format :json
    content_type :json, 'application/json; charset=utf-8'
    version 'v1', using: :header, vendor: 'siripoom'

    rescue_from ActiveRecord::RecordNotFound do |error|
      error!(error.message, 404)
    end

    rescue_from ActiveRecord::RecordNotUnique do |error|
      error!(error.message, 422)
    end

    helpers V1::Helpers::AuthorizationHelper

    mount V1::BookAPI
    mount V1::UserAPI
  end
end
