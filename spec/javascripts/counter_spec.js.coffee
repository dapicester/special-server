describe "Character counter", ->
  beforeEach ->
    loadFixtures("counter-div.html")

  it "should be initialized at MAXLEN", ->
    expect($("#micropost_form")).toHaveText("")
    expect($(".counter")).toHaveText("140")

