describe "Sanity check", ->
  it "passes", ->
    expect(true).toBe(true)

  xit "is disabled", ->
    expect(true).toBe(false)

  it "uses jQuery", ->
    expect(typeof jQuery).not.toEqual('undefined')
    expect(typeof $).not.toEqual('undefined')
    expect(typeof jQuery).toEqual(typeof $)


describe "Fixture check", ->
  beforeEach ->
    loadFixtures('sanity')

  it "loads the fixture", ->
    expect($('#title')).toHaveText('Test fixture')
    #FIXME expect($('#par').text()).toHaveText(/Test paragraph/)

  it "set the text", ->
    $('#par').text('New content')
    expect($('#par')).toHaveText('New content')

  it "set the number", ->
    $('#par').text(123)
    expect($('#par')).toHaveText('123')
