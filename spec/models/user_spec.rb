require 'spec_helper'

describe User do
  subject { build(:user) }

  it { should have_many :memberships }
  it { should belong_to :role }
  it { should be_valid }

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
