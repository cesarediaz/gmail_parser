class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    # replace with your authenticate method
    skip_before_action :authenticate_user!
  
    def google_oauth2
      auth = request.env["omniauth.auth"]
      user = User.where(provider: auth["provider"], uid: auth["uid"])
              .first_or_initialize(email: auth["info"]["email"])
      user.password = Devise.friendly_token[0,20]
      user.save!
  
      user.remember_me = true
      sign_in(:user, user)
  
      redirect_to after_sign_in_path_for(user)
    end

    def self.from_omniauth(access_token)
        data = access_token.info
        user = User.where(email: data['email']).first
    
        # Uncomment the section below if you want users to be created if they don't exist
        unless user
            user = User.create(name: data['name'],
               email: data['email'],
               password: Devise.friendly_token[0,20]
            )
        end
        user
    end
  end
