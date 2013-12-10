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

  def self.available_user?(id, user, from, to = nil)
    user_memberships = with_user(user).not_in(:_id => [id])
    if to
      user_memberships.each do |membership|
        if membership.to
          return false if (from <= membership.to) && (membership.from <= to)
        else
          return false if membership.from <= to
        end
      end
    else
      user_memberships.each do |membership|
        if membership.to
          return false if from <= membership.to
        else
          return false
        end
      end
    end
    true
  end

  private

  def validate_from_to
    if to.present? && from > to
      errors.add(:to, "can't be before from date")
    end
  end

  def validate_user_available
    unless self.class.available_user?(id, user, from, to)
      errors.add(:user, "user not available")
    end
  end
end
