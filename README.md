# streak

streak is a library for calculating win/loss streaks. It uses Redis as its backend for collecting the data. 
This is a CoffeeScript port of the original [streak](https://github.com/czarneckid/streak) Ruby gem.

## Installation

[Placeholder for npm installation instructions]

## Usage

streak is configurable with respect to its keys to allow for tracking other positive/negative things in a game like wins and losses, kills and deaths, etc.

    Streak.positive_key.should.equal('wins')
    Streak.positive_total_key.should.equal('wins_total')
    Streak.positive_streak_key.should.equal('wins_streak')
    Streak.negative_key.should.equal('losses')
    Streak.negative_total_key.should.equal('losses_total')
    Streak.negative_streak_key.should.equal('losses_streak')
    Streak.total_key.should.equal('total')


```javascript
# Configuration
Redis = require('redis').createClient();

Streak.configure(function() {
  this.redis = Redis;
  this.namespace = 'streak';
  this.positive_key = 'wins';
  this.positive_total_key = 'wins_total';
  this.positive_streak_key = 'wins_streak';
  this.negative_key = 'losses';
  this.negative_total_key = 'losses_total';
  this.negative_streak_key = 'losses_streak';
  this.total_key = 'total';
});

Streak.aggregate('david', 3, function(replies_callback) {  
});

Streak.aggregate('david', -2, function(replies_callback) {  
});

Streak.aggregate('david', 5, function(replies_callback) {  
});

Streak.aggregate('david', -1, function(replies_callback) {  
});

Streak.statistics('david', function(statistics_callback) {
  
});

# { wins: 0,
#   wins_total: 8,
#   wins_streak: 5,
#   losses: 1,
#   losses_total: 3,
#   losses_streak: 2,
#  total: 11 } 

Streak.resetStatistics('david', function(callback) {
  
});

Streak.statistics('david', function(statistics_callback) {
  
});

# { wins: 0,
#   wins_total: 0,
#   wins_streak: 0,
#   losses: 0,
#   losses_total: 0,
#   losses_streak: 0,
#  total: 0 } 

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2012 David Czarnecki. See LICENSE for further details.
