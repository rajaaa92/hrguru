class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :first_name
  field :last_name
  field :email
end
