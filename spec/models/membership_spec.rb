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
  it { should have_field(:billable).of_type(Mongoid::Boolean) }
  it { should validate_inclusion_of(:billable).to_allow([true, false]) }

  describe '#validate_from_to' do
    it "should add an error if 'to' is before 'from'" do
      subject.to = subject.from - 2.days
      subject.send :validate_from_to
      expect(subject.errors[:to]).to include("can't be before from date")
    end
  end

  describe '#validate_duplicate_project' do
    let(:user) { create(:user) }
    let(:project) { create(:project) }
    let(:membership) { build(:membership, user: user, project: project) }

    before do
      [
        [Time.new(2013, 1, 1), Time.new(2013, 6, 1)],
        [Time.new(2013, 6, 2), Time.new(2013, 8, 30)],
        [Time.new(2013, 10, 1), nil]
      ].each { |time_range| create(:membership, user: user, project: project, from: time_range[0], to: time_range[1]) }
    end

    context "valid" do
      [
        [Time.new(2012, 1, 1), Time.new(2012, 6, 1)],
        [Time.new(2013, 9, 1), Time.new(2013, 9, 30)]
      ].each do |time_range|
        it "start #{time_range[0]} ends #{time_range[1]}" do
          membership.from, membership.to = time_range
          expect(membership).to be_valid
        end
      end
    end

    context "invalid" do
      [
        [Time.new(2012, 1, 1), nil],
        [Time.new(2013, 11, 1), nil],
        [Time.new(2013, 1, 1), Time.new(2013, 5, 1)]
      ].each do |time_range|
        it "start #{time_range[0]} ends #{time_range[1]}" do
          membership.from, membership.to = time_range
          expect(membership).to_not be_valid
        end
      end
    end
  end
end
