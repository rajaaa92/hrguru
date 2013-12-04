class Membership
  include Mongoid::Document
  include Mongoid::Timestamps

  field :form, type: Time
  field :to, type: Time

  belongs_to :user
  belongs_to :project
end
