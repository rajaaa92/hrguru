class Hrguru.Views.MembershipsBase extends Backbone.View
  initialize: ->
    @$('#membership_to,#membership_from').datepicker
      daysOfWeekDisabled: "0,6"
      autoclose: true
      todayHighlight: true
      format: "yyyy-mm-dd"
