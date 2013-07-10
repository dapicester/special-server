# TODO include in each view requiring Ajax pagination (or in application.js)
$ ->
  $(document).on 'click', '.pagination a', ->
    $.getScript this.href
    false
