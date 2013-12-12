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

  scope :with_role, ->(role) { where(role: role) }
  scope :with_user, ->(user) { where(user: user) }
  scope :active, -> { any_of({ :from.lt => Time.now, to: nil }, { :from.lt => Time.now, :to.gt => Time.now })}

  private

  def validate_from_to
    if to.present? && from > to
      errors.add(:to, "can't be before from date")
    end
  end
end
