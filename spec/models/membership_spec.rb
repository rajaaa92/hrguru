describe Membership do
  subject { build(:membership, from: Time.now) }

  it { should belong_to :user }
  it { should belong_to :project }
  it { should belong_to :role }
  it { should be_valid }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:project) }
  it { should validate_presence_of(:role) }
  it { should be_timestamped_document }
  it { should have_field(:from).of_type(Time) }
  it { should have_field(:to).of_type(Time) }

  describe '#validate_from_to' do
    it "should add an error if 'to' is before 'from'" do
      subject.to = subject.from - 2.days
      subject.send :validate_from_to
      expect(subject.errors[:to]).to include("can't be before from date")
    end
  end
end
