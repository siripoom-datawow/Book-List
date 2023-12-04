require 'bcrypt'

module V1
  class UserAPI < Grape::API

    namespace 'user' do

      desc 'Create user'

        params do
          requires :email, type: String, desc: 'User email'
          requires :password, type: String, desc: 'User password'
        end

        post '/sign_up' do
          email = params[:email]
          password = params[:password]

          encrypted_password = BCrypt::Password.create(password)
          user = User.create(email: email, encrypted_password: encrypted_password)

          if user.valid?
            { status: 'success', message: 'User created successfully' }
          else
            error!({ error: 'Validation failed', details: user.errors.full_messages }, 422)
          end
        end

      desc 'Login'

        params do
          requires :email, type: String, desc: 'User email'
          requires :password, type: String, desc: 'User password'
        end

        post '/sign_in' do
          email = params[:email]
          password = params[:password]

          user = User.find_by({email:email})

          unless user.present?
            raise ActiveRecord::RecordNotFound
          end

          decrypted_password = BCrypt::Password.new(user.encrypted_password)

          if decrypted_password == password
            return {status:"success", auth_token: user.auth_token}
          else
            return  { status: 'fail', message: 'Invalid email or password' }
          end
      end
    end
  end
end
