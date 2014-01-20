class Hrguru.Views.Dashboard.EditMembershipPopup extends Marionette.CompositeView

  className: 'editPopup'
  template: JST['dashboard/edit_membership_popup']

  initialize: ->
    @$el.prop "id", @model.get("id")

