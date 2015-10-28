Helper = require('hubot-test-helper')
chai = require 'chai'
nock = require 'nock'

expect = chai.expect

helper = new Helper('../src/foldme.coffee')

describe 'foldme integration', ->
  room = null

  beforeEach ->
    room = helper.createRoom()
    do nock.disableNetConnect
    nock('http://foldme.herokuapp.com')
      .get('/random')
      .reply(200, { scotch_fold: 'http://imgur.com/fold.png' })
      .get('/bomb?count=5')
      .reply(200, { scotch_folds: ['http://imgur.com/fold1.png', 'http://imgur.com/fold2.png'] })
      .get('/count')
      .times(5)
      .reply(200, { fold_count: 365 })

  afterEach ->
    room.destroy()
    nock.cleanAll()

  context 'user requests a Scottish Fold', ->
    beforeEach (done) ->
      room.user.say 'alice', 'hubot fold me'
      setTimeout done, 100

    it 'should respond with a fold url', ->
      expect(room.messages).to.eql [
        [ 'alice', 'hubot fold me' ]
        [ 'hubot', 'http://imgur.com/fold.png' ]
      ]

  context 'user requests a Fold bomb', ->
    beforeEach (done) ->
      room.user.say 'alice', 'hubot fold bomb'
      setTimeout done, 100

    it 'should respond with a fold bomb', ->
      expect(room.messages).to.eql [
        ['alice', 'hubot fold bomb' ]
        ['hubot', 'http://imgur.com/fold1.png']
        ['hubot', 'http://imgur.com/fold2.png']
      ]

  context 'user requests the number of Scottish folds', ->
    beforeEach (done) ->
      room.user.say 'alice', 'hubot how many folds are there'
      room.user.say 'alice', 'hubot how many folds are there?'
      room.user.say 'alice', 'hubot how many scottish folds are there'
      room.user.say 'alice', 'hubot how many scottish folds are there?'
      room.user.say 'alice', 'hubot how many scottish FOLDS are there?'
      setTimeout done, 100

    it 'should respond with the count each time', ->
      expect(room.messages).to.eql [
        [ 'alice', 'hubot how many folds are there' ]
        [ 'alice', 'hubot how many folds are there?' ]
        [ 'alice', 'hubot how many scottish folds are there' ]
        [ 'alice', 'hubot how many scottish folds are there?' ]
        [ 'alice', 'hubot how many scottish FOLDS are there?' ]
        [ 'hubot', 'There are 365 Scottish Folds' ]
        [ 'hubot', 'There are 365 Scottish Folds' ]
        [ 'hubot', 'There are 365 Scottish Folds' ]
        [ 'hubot', 'There are 365 Scottish Folds' ]
        [ 'hubot', 'There are 365 Scottish Folds' ]
      ]
