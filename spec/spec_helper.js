require('coffee-script');
require('should');
Redis = require('redis').createClient();
Redis.select(15);
Streak = require('../lib/');
Streak.configure(function() {
  this.redis = Redis;
});
