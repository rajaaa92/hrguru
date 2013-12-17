class User
  include Mongoid::Document
  include Mongoid::Timestamps

  devise :database_authenticatable, :trackable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2, :github]

  field :encrypted_password
  field :sign_in_count, type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at, type: Time
  field :current_sign_in_ip
  field :last_sign_in_ip

  field :first_name
  field :last_name
  field :email
  field :gh_nick
  field :employment
  field :intern_start, type: Date
  field :intern_end, type: Date
  field :phone
  field :recruited, type: Date

  has_many :memberships
  belongs_to :role

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validate :validate_internship

  scope :by_name, -> { asc(:first_name, :last_name) }

  def self.create_from_google!(params)
    user = User.where(email: params['email']).first
    return user if user.present?

    fields = %w(first_name last_name email)
    attributes = fields.reduce({}) { |mem, key| mem.merge(key => params[key]) }
    attributes['password'] = Devise.friendly_token[0, 20]

    User.create!(attributes)
  end

  def github_connected?
    gh_nick.present?
  end

  def current_projects
    today = Date.today
    memberships.includes(:project).or({ :from.lte => today, to: nil }, { :from.lte => today, :to.gte => today }).map(&:project)
  end

  def validate_internship
    if intern_start && intern_end
      errors.add(:intern_end, "internship must not end before it starts") if intern_start > intern_end
    end
  end
end
