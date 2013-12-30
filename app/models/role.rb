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

  validates :name, presence: true

  default_scope asc(:priority)

  def to_s
    name
  end
end
