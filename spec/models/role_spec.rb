describe Role do
  subject { build(:role) }

  it { should have_many :memberships }
  it { should validate_presence_of(:name) }
  it { should be_valid }
  it { should have_field(:name).of_type(String) }

  describe "#to_s" do
    it "should return name" do
      subject.name = "junior"
      expect(subject.to_s).to eq("junior")
    end
  end
end
