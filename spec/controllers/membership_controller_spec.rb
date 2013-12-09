require 'spec_helper'

describe MembershipsController do
  before(:each) do
    sign_in create(:user)
  end

  describe "#index" do
    render_views

    let(:user) { create(:user, first_name: "Marian") }

    before do
      create(:membership, role: create(:role, name: "junior"))
      create(:membership, role: create(:role, name: "senior"))
    end

    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "exposes memberships" do
      get :index
      expect(controller.memberships.count).to be 2
    end

    it "should display memberships on view" do
      get :index
      expect(response.body).to match /junior/
      expect(response.body).to match /senior/
    end
  end

  describe "#new" do
    before { get :new }

    it "responds successfully with an HTTP 200 status code" do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "exposes new membership" do
      expect(controller.membership.created_at).to be_nil
    end
  end

  describe "#create" do
    let(:params) do
      params = build(:membership).attributes
      params.delete("_id")
      params
    end

    context "with valid attributes" do
      it "creates a new membership" do
        expect { post :create, membership: params }.to change(Membership, :count).by(1)
      end
    end

    context "with invalid attributes" do
      it "does not save" do
        params["role_id"] = "data"
        expect { post :create, membership: params }.to_not change(Membership, :count)
      end
    end
  end

  describe "#destroy" do
    let!(:membership) { create(:membership) }

    it "deletes the membership" do
      expect { delete :destroy, id: membership }.to change(Membership, :count).by(-1)
    end
  end

  describe '#update' do
    let!(:membership) { create(:membership, user: create(:user, first_name: "Marian")) }

    it "exposes membership" do
      put :update, id: membership, membership: membership.attributes
      expect(controller.membership).to eq membership
    end

    context "valid attributes" do
      it "changes membership's attributes" do
        attributes = attributes_for(:membership)
        attributes["user_id"] = create(:user, first_name: "Hela").id
        put :update, id: membership, membership: attributes
        membership.reload
        expect(membership.user.first_name).to eq "Hela"
      end
    end

    context "invalid attributes" do
      it "does not change membership's attributes" do
        put :update, id: membership, membership: attributes_for(:membership, project_id: nil)
        membership.reload
        expect(membership.project).to be
      end
    end
  end
end
