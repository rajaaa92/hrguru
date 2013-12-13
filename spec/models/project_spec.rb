describe Project do
  subject { build(:project) }

  it { should have_many :memberships }
  it { should be_valid }
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of(:name).case_insensitive }
end
