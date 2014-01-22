class Hrguru.Views.Dashboard.EditMembershipPopup extends Marionette.CompositeView

  className: 'editPopup'
  template: JST['dashboard/edit_membership_popup']

  events:
    'click .submit' : 'updateMembership'

  ui:
    input_from: '.from'
    input_to: '.to'
    billable: '.billable'

  initialize: ->
    @$el.prop "id", @model.get("id")
    @listenTo(Backbone, 'membership:editMembership', @beforeShowPopup)

  onRender: ->
    @fillMembershipPopupForm()
    @initDatePicker()

  beforeShowPopup: ->
    @fillMembershipPopupForm()

  initDatePicker: ->
    @$el.find('input.date_picker').datepicker
      autoclose: true
      todayHighlight: true
      format: "yyyy-mm-dd"

  input_date: (date) ->
    return '' unless date?
    moment(date).format 'YYYY-MM-DD'

  fillMembershipPopupForm: ->
    @ui.input_from.val @input_date @model.get('from')
    @ui.input_to.val @input_date @model.get('to')
    @ui.billable.prop('checked', @model.get('billable')?)

  updateMembership: (event) ->
    @model.save({ from: @ui.input_from.val(), to: @ui.input_to.val(), billable: @ui.billable.prop('checked')},
      patch: true
      success: (model, response, options) =>
        Messenger().success("Membership has been updated")
        @$el.modal('hide')
      error: (model, xhr) => @showError(xhr.responseJSON.errors)
    )

  showError: (errorsJSON = {}) ->
    for attr, errors of errorsJSON
      Messenger().error("#{attr} #{msg}") for msg in errors
