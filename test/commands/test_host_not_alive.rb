require 'test_helper'


class TestHostNotAlive < Test::Unit::TestCase
  include BeNotified::Commands
  
  def setup
    @packets = 1
  end
  
  def test_host_is_up
    expects(:run_system).with('ping -c 1 example.com').returns(PING_SUCCESS)
    assert ! host_not_alive?('example.com', @packets )
  end
  
  def test_host_is_down_timeout
    expects(:run_system).with('ping -c 1 example.com').returns(PING_FAIL)
    assert host_not_alive?('example.com', @packets)
  end
  
  PING_SUCCESS =<<-END
64 bytes from example.com: icmp_seq=0 ttl=64 time=0.033 ms
  END
  
  PING_FAIL =<<-END
Request timeout for icmp_seq 0
  END
end