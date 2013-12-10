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

  describe '#validate_user_available' do
    let(:user) { create(:user) }
    let!(:membership_without_end) { create(:membership, user: user, from: Time.new(2014, 1, 1, 11, 10), to: nil) }
    let!(:membership) { create(:membership, from: Time.new(2013, 8, 1, 11, 10), user: user) }

    before { subject.user = user }

    after do
      subject.send :validate_user_available
      expect(subject.errors[:user]).to include("user not available")
    end

    context "when given range" do
      it "is inside existing one" do
        subject.from = membership.from + 2.days
        subject.to = membership.to
      end

      it "ends in existing one and starts earlier" do
        subject.from = membership.from - 2.days
        subject.to = membership.to
      end

      it "starts in existing one and ends later" do
        subject.from = membership.from + 2.days
        subject.to = membership.to + 2.days
      end

      it "starts earlier and ends later than existing one" do
        subject.from = membership.from - 2.days
        subject.to = membership.to + 2.days
      end

      it "ends in membership without end date" do
        subject.from = membership_without_end.from - 2.days
        subject.to = membership_without_end.from
      end

      it "starts in membership without end date" do
        subject.from = membership_without_end.from
        subject.to = subject.from + 1.month
      end

      it "starts earlier and ends later than one without end date" do
        subject.from = membership_without_end.from - 2.days
        subject.to = membership_without_end.from + 2.days
      end
    end

    context "when given from" do
      before { subject.to = nil }

      it "starts later than one without end date" do
        subject.from = membership_without_end.from + 2.days
      end

      it "starts earlier than one without end date" do
        subject.from = membership_without_end.from - 2.days
      end

      it "starts in range of existing one" do
        subject.from = membership.from
      end

      it "starts earlier than existing one" do
        subject.from = membership.from - 2.days
      end
    end
  end
end
