class ProjectsController < ApplicationController

  expose(:project, attributes: :project_params)
  expose(:projects)

  def create
    if project.save
      redirect_to project, notice: "Project created!"
    else
      render :new
    end
  end

  def update
    if project.save
      redirect_to project, alert: "Project updated!"
    else
      render :edit
    end
  end

  def destroy
    redirect_to(projects_url, alert: "Project deleted!") if project.destroy
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end
end
