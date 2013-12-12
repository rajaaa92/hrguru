class Hrguru.Models.Membership extends Backbone.Model

class Hrguru.Collections.Memberships extends Backbone.Collection
  model: Hrguru.Models.Membership
  url: Routes.memberships_path()
