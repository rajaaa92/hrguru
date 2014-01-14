class Role
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Orderable

  after_create :move_to_bottom

  has_many :memberships
  has_many :users

  orderable column: :priority
  field :name, type: String
  field :color, type: String
  field :billable, type: Mongoid::Boolean, default: false

  validates :name, presence: true
  validates :billable, inclusion: { :in => [true, false] }

  default_scope asc(:priority)
  scope :billable, where(billable: true)
  scope :non_billable, where(billable: false)

  def to_s
    name
  end
end
