class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name

  has_many :memberships
end
