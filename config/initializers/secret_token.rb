# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Hrguru::Application.config.secret_key_base = ENV['SECRET_TOKEN_KEY'] || '295badce0bd702c7984846294afab07745ca5268c9bae58707664cf0c8d7d5f61e4198852edfb49f0282f7f10f2a95404915fb517395f975cd05a7eedf42ae1b'
