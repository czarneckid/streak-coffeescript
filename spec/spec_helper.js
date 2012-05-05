require('coffee-script');
require('should');
Redis = require('redis').createClient();
Streak = require('../lib/');
Streak.configure(function() {
  this.redis = Redis;
});
