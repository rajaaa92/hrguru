collection users

extends "users/base"

node(:gravatar) { |user| user.gravatar_image(size: 40) }
node(:github) { |user| user.github_link }
