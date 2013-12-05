class OmniauthCallbacksController <  ApplicationController
  skip_before_filter :authenticate_user!, only: :google_oauth2
  before_filter :check_ng_person, only: :google_oauth2

  def google_oauth2
    user = User.create_from_google!(env['omniauth.auth']['info'])
    sign_in(user)
    redirect_to root_path
  end

  def github

  end

  private

  def check_ng_person
    if env['omniauth.auth']['extra']['raw_info']['hd'] != 'netguru.pl'
      redirect_to root_path, error: 'No ng person'
    end
  end
end
