MAXLEN = 140
gray = "#999999"
red = "red"

update = (len) ->
  counter = $(".counter")
  counter.text(MAXLEN - len)
  if len > MAXLEN
    counter.css("color",red)
  else
    counter.css("color",gray)
  return

$(->
  update($("#micropost_form").html().length)
  return
)

window.count = (val) ->
  update(val.value.length)
  return
