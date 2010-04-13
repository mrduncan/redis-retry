$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'test/unit'
require 'mocha'
require 'redis'
require 'redis/retry'

class TestRedisRetry < Test::Unit::TestCase
  def setup
    @r = Redis.new :db => 15
    @redis = Redis::Retry.new(:tries => 10, :wait => 0, :redis => @r)
    @redis.flushdb
  end

  def test_should_set_and_get_without_retries
    @redis['foo'] = 'bar'
    assert_equal 'bar', @redis['foo']
  end

  def test_should_retry_after_receiving_connection_refused
    @r.stubs(:send).raises(Errno::ECONNREFUSED).then.returns(true)
    assert @redis['foo']
  end

  def test_should_retry_as_many_times_as_possible
    send = sequence('send')
    @r.stubs(:send).raises(Errno::ECONNREFUSED).times(9).in_sequence(send)
    @r.stubs(:send).returns(true).in_sequence(send)
    assert @redis['foo']
  end

  def test_should_fail_if_retries_are_used_up
    @r.stubs(:send).raises(Errno::ECONNREFUSED).times(10)
    assert_raise(Errno::ECONNREFUSED) { @redis['foo'] }
  end

  def test_should_reset_tries_for_every_call
    # Mocha doesn't seem to like the two #raises with the #returns between
    # unless they are distinguished by expecting different input params
    send = sequence('send')
    @r.stubs(:send).with(:[], 'foo').raises(Errno::ECONNREFUSED).times(8).in_sequence(send)
    @r.stubs(:send).with(:[], 'foo').returns(true).in_sequence(send)
    @r.stubs(:send).with(:[], 'bar').raises(Errno::ECONNREFUSED).times(8).in_sequence(send)
    @r.stubs(:send).with(:[], 'bar').returns(true).in_sequence(send)
    assert @redis['foo']
    assert @redis['bar']
  end
end
