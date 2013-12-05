describe User do
  subject { build(:user) }

  it { should have_many :memberships }
  it { should be_valid }
end
