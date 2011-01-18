require 'test_helper'

class TestMonitor < Test::Unit::TestCase
  
  def setup
    # Make sure we always start fresh
    BeNotified::Configuration.instance_variable_set(:@options, nil)

    # Pretend that configuration file does not exists
    BeNotified::Configuration.stubs(:load_config_file).returns("")
  end
  
  def test_do_notify
    BeNotified::Notifier.any_instance.expects(:notify)
    
    monitor = BeNotified::Monitor.new {}    
    monitor.expects(:notifier_type).returns(BeNotified::Notifiers::Email)
    monitor.alert_when "test notification" do
       true
    end
  end
  
  def test_dont_notify
    monitor = BeNotified::Monitor.new {}
    monitor.expects(:notifier_type).never
    
    monitor.alert_when "do not notify" do
      false
    end
  end
  
  def test_notifier_default_type
    monitor = BeNotified::Monitor.new {}
    assert_equal BeNotified::Notifiers::Log, monitor.notifier_type
  end
end