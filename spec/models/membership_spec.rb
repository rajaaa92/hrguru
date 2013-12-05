describe Membership do
  subject { build(:membership) }

  it { should belong_to :user }
  it { should belong_to :project }
  it { should be_valid }
end
