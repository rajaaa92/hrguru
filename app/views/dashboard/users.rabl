collection users
attributes :id, :first_name, :last_name, :name, :email
node(:gravatar) { |user| user.gravatar_url(30) }
