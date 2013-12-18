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
  validate :validate_duplicate_project

  scope :with_role, ->(role) { where(role: role) }
  scope :with_user, ->(user) { where(user: user) }
  scope :active, -> { any_of({ :from.lt => Time.now, to: nil }, { :from.lt => Time.now, :to.gt => Time.now })}

  %w(user project role).each do |model|
    original_model = "original_#{model}"
    alias_method original_model, model

    define_method(model) do
      model.capitalize.constantize.unscoped { send original_model }
    end
  end

  private

  def validate_from_to
    if to.present? && from > to
      errors.add(:to, "can't be before from date")
    end
  end

  def validate_duplicate_project
    memberships = Membership.with_user(user).not_in(:_id => [id]).where(project_id: project.try(:id))

    if to.present?
      duplicate = memberships.or({ :from.lte => to, :to.gte => from }, { :from.lte => to, :to => nil })
    else
      duplicate = memberships.or({ to: nil }, { :to.gte => from })
    end

    errors.add(:project, "user is not available at given time for this project") if duplicate.exists?
  end
end
