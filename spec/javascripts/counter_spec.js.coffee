# see http://asciicasts.com/episodes/261-testing-javascript-with-jasmine

#= require counter

String.prototype.repeat = (num) ->
  new Array(num + 1).join(this)

describe "Character counter", ->

  it "counts the remaining characters", ->
    expect(Counter.avail("")).toEqual(MAXLEN)
    expect(Counter.avail("test")).toEqual(MAXLEN - "test".length)

  it "counts the remaining characters in micropost_form", ->
    loadFixtures("counter-div")

    FORM_ID = '#micropost_form'
    COUNTER_ID = '#counter'
    EVENT = 'input'

    form = $(FORM_ID)
    counter = $(COUNTER_ID)
    spyEvent = spyOnEvent(FORM_ID, EVENT)

    testEvent = ->
      expect(EVENT).toHaveBeenTriggeredOn(FORM_ID)
      expect(spyEvent).toHaveBeenTriggered()

    form.countAvailable()
    expect(counter).toHaveText(MAXLEN)
    expect(counter).not.toHaveClass(ERRCLASS)
    testEvent
    spyEvent.reset()

    form.val('Sample content').trigger(EVENT)
    expect(counter).toHaveText(MAXLEN - 'Sample content'.length)
    expect(counter).not.toHaveClass(ERRCLASS)
    testEvent

    longString = 'qazwsxedcrf'.repeat(14)
    form.val(longString).trigger(EVENT)
    expect(counter).toHaveText(MAXLEN - longString.length)
    expect(counter).toHaveClass(ERRCLASS)
    testEvent

