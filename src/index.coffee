Streak =
  redis: null
  namespace: 'streak'
  positive_key: 'wins'
  positive_total_key: 'wins_total'
  positive_streak_key: 'wins_streak'
  negative_key: 'losses'
  negative_total_key: 'losses_total'
  negative_streak_key: 'losses_streak'
  total_key: 'total'

  configure: (config) ->
    config.apply(@)

  aggregate: (id, count, callback) ->
    self = @

    if count >= 0
      transaction = @redis.multi()
      transaction.get "#{Streak.namespace}::#{Streak.positive_key}::#{id}"
      transaction.get "#{Streak.namespace}::#{Streak.positive_streak_key}::#{id}"
      transaction.exec (err, replies) ->
        inner_transaction = self.redis.multi()
        inner_transaction.set "#{Streak.namespace}::#{Streak.positive_streak_key}::#{id}", Math.max parseInt(replies[0] || 0) + count, parseInt(replies[1] || 0)
        inner_transaction.incrby "#{Streak.namespace}::#{Streak.positive_key}::#{id}", Math.abs count
        inner_transaction.incrby "#{Streak.namespace}::#{Streak.positive_total_key}::#{id}", Math.abs count
        inner_transaction.set "#{Streak.namespace}::#{Streak.negative_key}::#{id}", 0
        inner_transaction.incrby "#{Streak.namespace}::#{Streak.total_key}::#{id}", Math.abs count
        inner_transaction.exec (err, replies) ->
          callback(replies)
    else
      transaction = @redis.multi()
      transaction.get "#{Streak.namespace}::#{Streak.negative_key}::#{id}"
      transaction.get "#{Streak.namespace}::#{Streak.negative_streak_key}::#{id}"
      transaction.exec (err, replies) ->
        inner_transaction = self.redis.multi()
        inner_transaction.set "#{Streak.namespace}::#{Streak.negative_streak_key}::#{id}", Math.abs Math.max parseInt(replies[0] || 0) - count, parseInt(replies[1] || 0)
        inner_transaction.incrby "#{Streak.namespace}::#{Streak.negative_key}::#{id}", Math.abs count
        inner_transaction.incrby "#{Streak.namespace}::#{Streak.negative_total_key}::#{id}", Math.abs count
        inner_transaction.set "#{Streak.namespace}::#{Streak.positive_key}::#{id}", 0
        inner_transaction.incrby "#{Streak.namespace}::#{Streak.total_key}::#{id}", Math.abs count
        inner_transaction.exec (err, replies) ->
          callback(replies)

  statistics: (id, callback) ->
    transaction = @redis.multi()
    transaction.get "#{Streak.namespace}::#{Streak.positive_key}::#{id}"
    transaction.get "#{Streak.namespace}::#{Streak.positive_total_key}::#{id}"
    transaction.get "#{Streak.namespace}::#{Streak.positive_streak_key}::#{id}"
    transaction.get "#{Streak.namespace}::#{Streak.negative_key}::#{id}"
    transaction.get "#{Streak.namespace}::#{Streak.negative_total_key}::#{id}"
    transaction.get "#{Streak.namespace}::#{Streak.negative_streak_key}::#{id}"
    transaction.get "#{Streak.namespace}::#{Streak.total_key}::#{id}"
    transaction.exec (err, replies) ->
      callback(replies.map (reply) -> parseInt(reply || 0))

  resetStatistics: (id, callback) ->
    keys = [Streak.positive_key, Streak.positive_total_key, Streak.positive_streak_key, Streak.negative_key, Streak.negative_total_key, Streak.negative_streak_key, Streak.total_key]

    transaction = @redis.multi()
    for key in keys
      transaction.set("#{Streak.namespace}::#{key}::#{id}", 0)
    
    transaction.exec (err, replies) ->
      if err
        console.log 'Unable to call resetStatistics'
        callback(err)
      else
        callback(replies)

module.exports = Streak
