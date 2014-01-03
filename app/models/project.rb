class Project
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  after_destroy :end_mamberships

  field :name
  field :end_at, type: Time

  has_many :memberships

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def to_s
    name
  end

  private

  def end_mamberships
    memberships.update_all(to: Time.now)
  end
end
