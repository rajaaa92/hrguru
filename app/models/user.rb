class User
  include Mongoid::Document
  include Mongoid::Timestamps

  devise :database_authenticatable, :trackable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]

  field :encrypted_password
  field :sign_in_count, type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at, type: Time
  field :current_sign_in_ip
  field :last_sign_in_ip

  field :first_name
  field :last_name
  field :email

  has_many :memberships

  def self.create_from_google!(params)
    user = User.where(email: params['email']).first
    return user if user.present?

    fields = %w(first_name last_name email)
    attributes = fields.reduce({}) { |mem, key| mem.merge(key => params[key]) }
    attributes['password'] = Devise.friendly_token[0, 20]

    User.create!(attributes)
  end
end
