redis-retry
-----------

Requires the redis gem.

Automatically retries all Redis calls if the Redis server is not available.

    r = Redis::Retry.new(:tries => 3, :wait => 5, :redis => @r)

Redis::Retry will proxy all Redis calls.  If a `Errno::ECONNREFUSED` error
occurs, the command will be retried the specified number of times, waiting the
specified number of seconds between tries.  After all tries have been made
unsuccessfully, the `Errno::ECONNREFUSED` will be raised.

Useful to ensure that apps don't fail when Redis is unavailable for a short
amount of time.


Installation
============

    $ gem install redis-retry


Author
=====

Matt Duncan
matt@mattduncan.org
