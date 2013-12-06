class Membership
  include Mongoid::Document
  include Mongoid::Timestamps
  ROLES = [ 'senior', 'developer', 'junior', 'praktykant', 'pm', 'junior pm', 'qa', 'junior qa']

  field :from, type: Time
  field :to, type: Time

  belongs_to :user
  belongs_to :project
  belongs_to :role

  validates :user, presence: true
  validates :project, presence: true

  scope :with_role, ->(role) { where(role: role) }
end
