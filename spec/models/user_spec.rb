require 'spec_helper'

describe User do
  subject { build(:user) }

  it { should have_many :memberships }
  it { should belong_to :role }

  context "validation" do
    it { should be_valid }
    it { should validate_inclusion_of(:location).to_allow(['Warsaw', 'Poznan', 'Remotely']) }

    describe "internship" do
      context "valid" do
        it "with no end date" do
          subject.intern_end = nil
          expect(subject).to be_valid
        end
      end

      context "invalid" do
        it "with no start date" do
          subject.intern_start = nil
          expect(subject).to_not be_valid
        end

        it "with end date before start date" do
          subject.intern_end = subject.intern_start - 3.days
          expect(subject).to_not be_valid
        end
      end
    end
  end

  describe "#current_projects" do
    let(:user) { create(:user) }
    let!(:project) { create(:project, name: "google") }

    before { Timecop.freeze(Time.local(2013, 12, 1)) }
    after { Timecop.return }

    def time(year, month, day)
      Time.new(year, month, day)
    end

    it "expect projects list to include 'google' project" do
      create(:membership, from: time(2013, 11, 1), to: time(2014, 1, 1), user: user, project: project)
      expect(user.current_projects).to eq [project]
    end

    it "expect no projects" do
      create(:membership, from: time(2012, 1, 1), to: time(2013, 11, 30), user: user)
      expect(user.current_projects).to be_empty
    end

    it "expect projects array to include 2 projects" do
      create(:membership, from: time(2011, 1, 1), to: time(2012, 1, 1), user: user)
      create(:membership, from: time(2012, 1, 1), to: time(2014, 1, 1), user: user)
      create(:membership_without_to, from: time(2013, 1, 1), user: user)
      expect(user.current_projects.count).to eq 2
    end
  end
end
