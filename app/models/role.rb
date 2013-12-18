class Role
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  has_many :memberships
  has_many :users

  field :name, type: String

  validates :name, presence: true

  def to_s
    name
  end
end
