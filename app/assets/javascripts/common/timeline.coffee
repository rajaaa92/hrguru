(($, moment) ->
  $.fn.timeline = (events) ->
    $eventsTag = $("<div class='events'></div>").appendTo(this)

    timeline =
      $el: $eventsTag

      config:
        dayLength: 7

      render: ->
        [firstDate, lastDate] = @getLimits()
        @setEnds(firstDate, lastDate)

        html = @renderMonths(firstDate, lastDate)
        html += @renderEvent(e) for e in events
        @$el.html(html)

      getLimits: ->
        firstDate = new Date()
        lastDate = firstDate

        for e in events
          startDate = new Date(e.startDate)
          if startDate < firstDate
            firstDate = startDate
          else if lastDate < startDate
            lastDate = startDate
        [firstDate, lastDate]

      setEnds: (firstDate, lastDate) ->
        @startTimelineM = moment(firstDate)
        @endTimelineM = moment(lastDate)

        @startTimelineM.startOf "month"
        @endTimelineM.endOf "month"

      renderEvent: (event) ->
        offset = @eventOffset(moment(event.startDate))
        width = @eventWidth(event)

        "<div class='event' style='margin-left: #{offset}px'>
          <div class='time' style='width: #{width}px'></div>
          #{@renderEventTitle(event)}
        </div>"

      renderEventTitle: (event) ->
        display = (date) -> moment(event[date]).format "D MMM"
        endDate = -> if event.endDate then display('endDate') else 'unexpired'
        eventTitle = "<span>#{display('startDate')}"
        eventTitle += " - #{endDate()}" if event.startDate != event.endDate
        eventTitle += "</span> #{event.text}&nbsp;&nbsp;"

      renderMonths: (firstDate, lastDate) ->
        [html, width, days] = ["", 0, 0]
        months = moment(lastDate).diff(firstDate, "months")
        titleDateM = moment(firstDate)
        prevDate = titleDateM

        for n in [0..months]
          html += "<section class='month' style='left: #{width}px'>#{titleDateM.format("MMMM YYYY")}</section>"
          days += prevDate.daysInMonth()
          width = @daysLength(days)
          prevDate = titleDateM
          titleDateM.add("months", 1)
        html

      eventOffset: (startDateM) ->
        daysDiff = @daysDiff(startDateM, @startTimelineM)
        @daysLength(daysDiff)

      eventWidth: (event) ->
        startDate = event.startDate
        endDate = event.endDate
        daysDiff = if endDate then @daysDiff(moment(endDate), startDate) else @daysDiff(@endTimelineM, startDate)
        @daysLength(daysDiff)

      daysLength: (days) -> (days * @config.dayLength).toFixed(2)

      daysDiff: (firstDateM, secondDate) -> firstDateM.diff(secondDate, 'days')

    slider =
      $el: $eventsTag.parent()
      startingMousePostition: {}
      startingPagePosition: {}

      init: ->
        @$el.mousedown (event) =>
          @startingMousePostition =
            x: event.clientX
            y: event.clientY

          @startingPagePosition =
            x: @$el.scrollLeft()
            y: @$el.scrollTop()

          @$el.mousemove(@slide.bind(this))

        @$el.mouseup (event) => @$el.off('mousemove')

      slide: (event) ->
        event.preventDefault()
        x = @startingPagePosition.x + (@startingMousePostition.x - event.clientX)
        y = @startingPagePosition.y + (@startingMousePostition.y - event.clientY)
        @$el.scrollTo(x, y)

    timeline.render()
    slider.init()
    this
) jQuery, moment
