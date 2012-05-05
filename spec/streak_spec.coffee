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
                statistics.should.eql({
                  wins: 0,
                  wins_total: 8,
                  wins_streak: 5,
                  losses: 1,
                  losses_total: 3,
                  losses_streak: 2,
                  total: 11 })
                done()

  describe '#resetStatistics', ->
    it 'should reset all statistics', (done) ->
      Streak.aggregate 'david', 3, (replies) ->
        Streak.aggregate 'david', -2, (replies) ->
          Streak.aggregate 'david', 5, (replies) ->
            Streak.aggregate 'david', -1, (replies) ->
              Streak.statistics 'david', (statistics) ->
                statistics.should.eql({
                  wins: 0,
                  wins_total: 8,
                  wins_streak: 5,
                  losses: 1,
                  losses_total: 3,
                  losses_streak: 2,
                  total: 11 })

      Streak.resetStatistics 'david', (statistics) ->
        statistics.should.eql(['OK', 'OK', 'OK', 'OK', 'OK', 'OK', 'OK'])

      Streak.statistics 'david', (statistics) ->
        statistics.should.eql({
          wins: 0,
          wins_total: 0,
          wins_streak: 0,
          losses: 0,
          losses_total: 0,
          losses_streak: 0,
          total: 0 })

      done()
