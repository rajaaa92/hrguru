class ProjectsController < ApplicationController

  expose(:project, attributes: :project_params)
  expose(:projects)

  def create
    project.save ? redirect_to(project) : render(:new)
  end

  def update
    project.save ? redirect_to(project) : render(:edit)
  end

  def destroy
    redirect_to projects_url if project.destroy
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end
end
