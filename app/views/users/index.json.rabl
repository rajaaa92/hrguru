collection users
attributes :id, :name, :email, :role, :internship, :recruited, :employment, :phone
node(:gravatar) { |user| user.gravatar_image(size: 40) }
node(:github) { |user| user.github_link }
