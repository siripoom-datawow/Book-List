# frozen_string_literal: true

module UpdateCacheConcern
  extend ActiveSupport::Concern

  included do
    def update_cache(_method, key, value)
      Rails.cache.write(key, value)
    end
  end
end
