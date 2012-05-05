describe 'Streak', ->
  afterEach ->
    Streak.redis.flushdb (err, response) ->
      if err
        console.log 'Unable to flush database before tests'

  describe '#aggregate', ->
    it 'should collect the right statistics', (done) ->
      Streak.aggregate 'david', 1, (replies) ->
        replies.should.eql(['OK', 1, 1, 'OK', 1])

      Streak.aggregate 'david', 1, (replies) ->
        replies.should.eql(['OK', 2, 2, 'OK', 2])

      Streak.aggregate 'david', -2, (replies) ->
        replies.should.eql(['OK', 2, 2, 'OK', 4])

      done()

  describe '#statistics', ->
    it 'should return the default list of statistics if no keys list is provided', (done) ->
      Streak.aggregate 'david', 3, (replies) ->
        Streak.aggregate 'david', -2, (replies) ->
          Streak.aggregate 'david', 5, (replies) ->
            Streak.aggregate 'david', -1, (replies) ->
              Streak.statistics 'david', (statistics) ->
                statistics.should.eql([0, 8, 5, 1, 3, 2, 11])
                done()
