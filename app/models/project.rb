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

  def memberships_in_range(days)
    time = Time.now
    range = (time - days)..(time + days)
    User.unscoped { memberships.includes(:user).or({ from: range }, { to: range }) }
  end

  private

  def end_mamberships
    memberships.update_all(to: Time.now)
  end
end
