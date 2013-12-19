class Hrguru.Models.Role extends Backbone.Model

  priority: ->
    roles = ['pm', 'qa', 'senior', 'developer', 'junior', 'praktykant']
    roles.indexOf(@get('name')) + 1

class Hrguru.Collections.Roles extends Backbone.Collection
  model: Hrguru.Models.Role
