class User
  include Mongoid::Document
  devise :database_authenticatable, :registerable,
         :trackable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2, :github]

  include Mongoid::Timestamps
  include Mongoid::Paranoia

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
  field :location

  has_many :memberships
  belongs_to :role

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validate :validate_internship
  validates :location, inclusion: { in: %w(Warsaw Poznan Remotely) }, allow_blank: true

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
    now = Time.now
    memberships.includes(:project).or({ :from.lte => now, to: nil }, { :from.lte => now, :to.gte => now }).map(&:project)
  end

  def memberships_by_project
    Project.unscoped do
      memberships.includes(:project, :role).group_by(&:project_id).each_with_object({}) do |data, memo|
        memberships = data[1].sort{ |m1, m2| m2.from <=> m1.from }
        project = memberships.first.project
        memo[project] = MembershipDecorator.decorate_collection memberships
      end
    end
  end

  def validate_internship
    if intern_end
      if intern_start.nil?
        errors.add(:intern_start, "internship should have start date")
      elsif intern_start > intern_end
        errors.add(:intern_end, "internship must not end before it starts")
      end
    end
  end
end
