# to avoid automatic closure wrappers use "@" which is synonym
# for "this." and in this context means "window."

@MAXLEN = 140
@ERRCLASS = 'counter-error'

@Counter =
  avail: (text) ->
    MAXLEN - text.length

jQuery ->
  $.fn.countAvailable = ->
    $(this).on 'input propertychange', ->
      #TODO this + _counter
      len = Counter.avail( $(this).val() )
      counter = $('#counter')
      counter.text len
      if len >= 0
        counter.removeClass(ERRCLASS) if counter.hasClass(ERRCLASS)
      else
        counter.addClass(ERRCLASS) unless counter.hasClass(ERRCLASS)
    $(this).trigger 'input'
