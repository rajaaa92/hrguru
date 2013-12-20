class Role
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Orderable

  after_create :move_to_bottom

  orderable column: :priority

  has_many :memberships
  has_many :users

  field :name, type: String
  field :priority, type: Integer

  validates :name, presence: true

  default_scope asc(:priority)

  def to_s
    name
  end
end
