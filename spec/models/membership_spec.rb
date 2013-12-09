describe Membership do
  subject { build(:membership) }

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
      membership = build(:membership, from: Time.now, to: (Time.now - 2.days))
      membership.send :validate_from_to
      expect(membership.errors[:to]).to include("can't be before from date")
    end
  end

  describe '#validate_user_available' do
    let(:user) { create(:user) }
    let(:membership) { build(:membership, user: user) }

    before do
      create(:membership, from: Time.new(2013, 8, 1, 11, 10), to: Time.new(2013, 9, 1, 12, 2), user: user)
    end

    context "should add an error if given range" do
      after do
        membership.send :validate_user_available
        expect(membership.errors[:user]).to include("user not available")
      end

      it "is inside existing one" do
        membership.from = Time.new(2013, 8, 2, 11, 10)
        membership.to = Time.new(2013, 8, 10, 11, 10)
      end

      it "ends in existing one" do
        membership.from = Time.new(2012, 1, 1, 11, 10)
        membership.to = Time.new(2013, 8, 10, 11, 10)
      end

      it "starts in existing one" do
        membership.from = Time.new(2012, 8, 3, 11, 10)
        membership.to = Time.new(2016, 10, 3, 11, 10)
      end

      it "is around existing one" do
        membership.from = Time.new(2001, 8, 3, 11, 10)
        membership.to = Time.new(2016, 10, 3, 11, 10)
      end
    end
  end
end
