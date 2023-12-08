# frozen_string_literal: true

module V1
  class UserAPI < Grape::API
    namespace 'user' do
      desc 'Create User'

      params do
        requires :email, type: String, desc: 'User email'
        requires :password, type: String, desc: 'User password'
      end

      post '/sign_up' do
        email = params[:email]
        password = params[:password]
        user = User.create(email:, password:)

        if user.valid?
          { status: 'success', message: 'User created successfully' }
        else
          error!({ error: 'Validation failed', details: user.errors.full_messages }, 422)
        end
      end

      desc 'Sign In'

      params do
        requires :email, type: String, desc: 'User email'
        requires :password, type: String, desc: 'User password'
      end

      post '/sign_in' do
        email = params[:email]
        password = params[:password]

        user = User.find_by({ email: })

        raise ActiveRecord::RecordNotFound unless user.present?

        decrypted_password = BCrypt::Password.new(user.encrypted_password)

        return { status: 'success', auth_token: user.auth_token } if decrypted_password == password

        return { status: 'fail', message: 'Invalid email or password' }
      end

      desc 'Sign Out'

      delete '/sign_out' do
        current_user = Rails.cache.read('current_user')
        user = User.find(current_user)

        Rails.cache.delete('current_user')

        return { status: 'success', message: 'logout complete' } if user.regenerate_auth_token

        return { status: 'fail', message: 'logout fail' }
      end
    end
  end
end
