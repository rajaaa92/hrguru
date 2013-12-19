class Hrguru.Models.Membership extends Backbone.Model

class Hrguru.Collections.Memberships extends Backbone.Collection
  model: Hrguru.Models.Membership
  url: Routes.memberships_path()

  for_project: (project_id) ->
    new Backbone.VirtualCollection(@, { filter: { project_id: project_id } })
