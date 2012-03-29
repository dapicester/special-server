MAXLEN = 140
errClass = "counter-error"

class Counter
  constructor: (@form,@counter) ->
    @.count()

  count: ->
    len = MAXLEN - @form.val().length
    @counter.html(len)
    if len >= 0
      @counter.removeClass(errClass) if @counter.hasClass(errClass)
    else
      @counter.addClass(errClass) if not @counter.hasClass(errClass)
    return

$ ->
  form = $("#micropost_form")
  cc = new Counter(form, $("#counter"))

  form.keyup ->
    cc.count()
    return
  form.keydown ->
    cc.count()
    return
  return

