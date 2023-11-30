module UpdateCacheConcern
  extend ActiveSupport::Concern

  included do
    def update_cache(method,key,value)
      method
      Rails.cache.write(key,value)
    end
  end
end
