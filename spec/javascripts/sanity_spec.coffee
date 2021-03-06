describe "Sanity check", ->
  it "passes", ->
    expect(true).toBe true

  xit "is disabled", ->
    expect(true).toBe false

  it "uses jQuery", ->
    expect(typeof jQuery).not.toEqual 'undefined'
    expect(typeof $).not.toEqual 'undefined'
    expect(typeof jQuery).toEqual(typeof $)


describe "Fixture check", ->
  beforeEach ->
    loadFixtures 'sanity'

  it "loads the fixture", ->
    expect($ '#title').toHaveText 'Test fixture'
    expect($('#par').text()).toMatch /Test paragraph/

  it "sets the text with strings", ->
    $('#par').text 'New content'
    expect($ '#par').toHaveText 'New content'

  it "sets the text with numbers", ->
    $('#par').text 123
    expect($ '#par').toHaveText '123'
