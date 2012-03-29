describe "Character counter", ->
  beforeEach ->
    loadFixtures("counter-div.html")

  it "won't work", ->
    # cannot test counter because it includes $ -> 
    return
