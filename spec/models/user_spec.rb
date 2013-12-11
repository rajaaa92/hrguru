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
      Date.stub(:today).and_return(Date.new(2013, 12, 1))
    end

    def time(year, month, day)
      Time.new(year, month, day, 11, 10)
    end

    it "expect 'hrguru' project" do
      create(:membership_with_hrguru, from: time(2013, 11, 1), to: time(2014, 1, 1), user: user)
      expect(user.project.name).to eq 'hrguru'
    end

    it "expect no project" do
      create(:membership_with_hrguru, from: time(2013, 1, 1), to: time(2013, 1, 30), user: user)
      expect(user.project).to be_nil
    end

    it "expect to got project without end date" do
      create(:membership_with_hrguru_no_to, from: time(2011, 1, 1), user: user)
      expect(user.project.name).to eq 'hrguru'
    end

    it "expect to got current project" do
      create(:membership_with_hrguru, from: time(2013, 11, 1), to: time(2014, 12, 1), user: user)
      create(:membership, user: user, from: time(2016, 1, 1))
      create(:membership_without_to, user: user, from: time(2017, 1, 1))
      expect(user.project.name).to eq 'hrguru'
    end
  end
end
