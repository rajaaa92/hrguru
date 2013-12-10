require 'spec_helper'

describe User do
  subject { build(:user) }

  it { should have_many :memberships }
  it { should belong_to :role }
  it { should be_valid }

  describe "#project" do
    let(:user) { create(:user) }
    let!(:project) { create(:project, name: "google") }

    before do
      Time.stub(:now).and_return(Time.new(2013, 12, 1, 11, 10))
    end

    def create_membership(from, to, with_project = true)
      if with_project
        create(:membership, user: user, from: from, to: to, project: project)
      else
        create(:membership, user: user, from: from, to: to)
      end
    end

    def from(year, month, day)
      Time.new(year, month, day, 11, 10)
    end
    alias_method :to, :from

    it "expect 'google' project" do
      create_membership from(2013, 11, 1), to(2014, 1, 1)
      expect(user.project).to be project
    end

    it "expect no project" do
      create_membership from(2013, 1, 1), to(2013, 1, 30)
      expect(user.project).to be_nil
    end

    it "expect to got project without end date" do
      create_membership from(2011, 1, 1), nil
      expect(user.project).to be project
    end

    it "expect to got current project" do
      create_membership from(2013, 11, 1), to(2013, 12, 1)
      create(:membership, user: user, from: from(2016, 1, 1))
      create(:membership, user: user, from: from(2017, 1, 1), to: nil)
      expect(user.project).to be project
    end
  end
end
