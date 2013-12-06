class OmniauthCallbacksController <  ApplicationController
  skip_before_filter :authenticate_user!, only: :google_oauth2
  before_filter :check_ng_person, only: :google_oauth2

  def google_oauth2
    user = User.create_from_google!(request.env['omniauth.auth']['info'])
    sign_in(user)
    redirect_to root_path
  end

  def github
    github_nickname = request.env['omniauth.auth'][:info][:nickname]
    current_user.update_attributes(gh_nick: github_nickname)
    redirect_to root_path
  end

  private

  def check_ng_person
    if request.env['omniauth.auth']['extra']['raw_info']['hd'] != 'netguru.pl'
      redirect_to root_path, error: 'No ng person'
    end
  end
end
