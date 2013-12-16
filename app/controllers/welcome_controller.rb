class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!, only: :index
  skip_before_filter :connect_github, only: :github_connect

  def index
  end

  def github_connect
  end
end
