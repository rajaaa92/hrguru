class Role
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  has_many :memberships
  has_many :users

  field :name, type: String
  field :priority, type: Integer
  field :color, type: String

  validates :name, presence: true

  default_scope asc(:priority)

  def to_s
    name
  end
end
