class Membership
  include Mongoid::Document
  include Mongoid::Timestamps

  field :from, type: Time
  field :to, type: Time

  belongs_to :user
  belongs_to :project
  belongs_to :role

  validates :user, presence: true
  validates :project, presence: true
  validates :role, presence: true
  validates :from, presence: true

  validate :validate_from_to
  validate :validate_user_available

  scope :with_role, ->(role) { where(role: role) }
  scope :with_user, ->(user) { where(user: user) }

  def self.available_user?(user, from, to = nil)
    if to
      return false if with_user(user).where(:from.gte => from).and(:to.lte => to).exists?
      return false if with_user(user).where(:to.gte => from).and(:to.lte => to).exists?
      return false if with_user(user).where(:from.gte => from).and(:from.lte => to).exists?
      return false if with_user(user).where(:from.lte => from).and(:to.gte => to).exists?
    else
      return false if with_user(user).where(:to.gte => from).exists?
    end
    true
  end

  private

  def validate_from_to
    if to.present? and from > to
      errors.add(:to, "can't be before from date")
    end
  end

  def validate_user_available
    unless self.class.available_user?(user, from, to)
      errors.add(:user, "user not available")
    end
  end
end
