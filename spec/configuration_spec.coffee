describe 'Streak#configure', ->
  afterEach ->
    Streak.redis.flushdb (err, response) ->
      if err
        console.log 'Unable to flush database before tests'

  it 'should have default configuration options', (done) ->
    Streak.redis.should.not.be.nil
    Streak.namespace.should.equal('streak')
    Streak.positive_key.should.equal('wins')
    Streak.positive_total_key.should.equal('wins_total')
    Streak.positive_streak_key.should.equal('wins_streak')
    Streak.negative_key.should.equal('losses')
    Streak.negative_total_key.should.equal('losses_total')
    Streak.negative_streak_key.should.equal('losses_streak')
    Streak.total_key.should.equal('total')
    done()

