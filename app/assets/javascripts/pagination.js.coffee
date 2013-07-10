# TODO include in each view requiring Ajax pagination (or in application.js)
if history && history.pushState
  $ ->
    $(document).on 'click', '.pagination a', ->
      $.getScript this.href
      history.pushState null, document.title, this.href
      false
    $(window).on 'popstate', ->
      $.getScript location.href
      return
    return
