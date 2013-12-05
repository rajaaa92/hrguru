require 'spec_helper'

describe ProjectsController do
  before(:each) do
    sign_in create(:user)
  end

  describe "#index" do
    render_views

    before do
      create(:project, name: "dwhite")
      create(:project, name: "hrguru")
    end

    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "exposes projects" do
      get :index
      expect(controller.projects.count).to be 2
    end

    it "should display projects on view" do
      get :index
      expect(response.body).to match /dwhite/
      expect(response.body).to match /hrguru/
    end
  end

  describe "#show" do
    subject { create(:project) }
    before { get :show, id: subject }

    it "responds successfully with an HTTP 200 status code" do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "exposes project" do
      expect(controller.project).to be subject
    end
  end

  describe "#new" do
    before { get :new }

    it "responds successfully with an HTTP 200 status code" do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "exposes new project" do
      expect(controller.project.created_at).to be_nil
    end
  end

  describe "#create" do
    context "with valid attributes" do
      subject { attributes_for(:project) }

      it "creates a new project" do
        expect { post :create, project: subject }.to change(Project, :count).by(1)
      end
    end

    context "with invalid attributes" do
      subject { attributes_for(:invalid_project) }

      it "does not save" do
        expect { post :create, project: subject }.to_not change(Project, :count)
      end
    end
  end

  describe "#destroy" do
    let!(:project) { create(:project) }

    it "deletes the contact" do
      expect { delete :destroy, id: project }.to change(Project, :count).by(-1)
    end
  end

  describe '#update' do
    let!(:project) { create(:project, name: "hrguru") }

    it "exposes project" do
      put :update, id: project, project: project.attributes
      expect(controller.project).to eq project
    end

    context "valid attributes" do
      it "changes project's attributes" do
        put :update, id: project, project: attributes_for(:project, name: "dwhite")
        project.reload
        expect(project.name).to eq "dwhite"
      end
    end

    context "invalid attributes" do
      it "does not change project's attributes" do
        put :update, id: project, project: attributes_for(:project, name: nil)
        project.reload
        expect(project.name).to eq "hrguru"
      end
    end
  end
end
