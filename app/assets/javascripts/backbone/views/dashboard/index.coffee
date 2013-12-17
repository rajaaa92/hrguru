class Hrguru.Views.DashboardIndex extends Backbone.View

  el: '#main-container'
  completionItem: JST['dashboard/completion']
  item: JST['dashboard/item']

  events:
    'click .entries' : 'activateSelectize'
    'click .entry .remove' : 'finishMembership'
    'click .entry' : 'showDetails'
    'blur .selectize-input input' : 'hideDetails'

  initialize: ->
    @now = moment()
    @users = new Hrguru.Collections.Users(gon.users)
    @memberships = new Hrguru.Collections.Memberships(gon.memberships)
    @fillTable()
    @showAutocomplation()

  fillTable: ->
    @memberships.each (model) => @addEntry(model)

  addEntry: (membership) ->
    role = membership.get('role_id')
    project = membership.get('project_id')
    $input = @$("td[data-role=#{role}][data-project=#{project}] input")
    if $input.val()
      values = $input.val().split(',')
      values.push(membership.get('user_id'))
      results = values.join(',')
    else
      results = membership.get('user_id')
    $input.val(results)

  showAutocomplation: ->
    self = @
    @$('#projects-users input').selectize
      create: false
      valueField: 'id'
      labelField: 'name'
      searchField: 'name'
      options: @users.toJSON()
      render:
        item: (item, escape) => @item(item)
        option: (item, escape) => @completionItem(item)
      onItemAdd: @newMembership
      onInitialize: -> self.initializeDetails(@) if @items.length > 0

  initializeDetails: (selectize) ->
    selectize.$control.find('.entry').popover
      content: 'test test'
      container: 'body'
      placement: 'top'
      trigger: 'manual'

  newMembership: (value, $item) =>
    project = $item.parents('td').data('project')
    role = $item.parents('td').data('role')
    from = moment(gon.currentTime).add(moment().diff(@now))
    attributes = { project_id: project, role_id: role, user_id: value, from: from }
    @memberships.create(attributes, { wait: true })

  finishMembership: (event) ->
    event.preventDefault()
    event.stopPropagation()

    @$membership_entry = $(event.currentTarget)
    project = @$membership_entry.parents('td').data('project')
    role = @$membership_entry.parents('td').data('role')
    @user = @$membership_entry.parent('.entry').data('value')
    membership = @memberships.findWhere(project_id: project, role_id: role, user_id: @user)

    to = moment(gon.currentTime).add(moment().diff(@now))
    membership.save({ to: to.format() }, { patch: true, success: @membershipFinished })

  membershipFinished: =>
    input = @$membership_entry.parents('.selectize-control').siblings('input.selectized')
    input[0].selectize.removeItem(@user)

  showDetails: (event) ->
    $target = $(event.currentTarget)
    @active_popover?.popover('hide')
    if @active_popover != $target
      @active_popover = $target.popover('show')

  hideDetails: (event) ->
    @active_popover?.popover('hide')

  activateSelectize: (event) ->
    $target = $(event.target)
    return if !$target.is('td')
    $target.find('input.selectized')[0].selectize.open()
