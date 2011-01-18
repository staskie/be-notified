require 'test_helper'

class TestLogNotifier < Test::Unit::TestCase
  include BeNotified::Notifiers
  include Log4r
  
  def setup
    # Make sure we always start fresh
    BeNotified::Configuration.instance_variable_set(:@options, nil)

    # Pretend that configuration file does not exists
    BeNotified::Configuration.stubs(:load_config_file).returns("")
  end
  
  def test_configuration_access
    assert Log.new.respond_to? :options
  end
  
  def test_stdout_outputter
    log = Log.new
    
    # By default monitor should log to stdout
    assert log.logger.outputters.include?(Outputter.stdout)
  end
  
  def test_file_outputter
    log = Log.new
    
    BeNotified::Configuration.options.merge!({:logger_file => '/tmp/be_notified.log'})
    
    # Set expectation on FileOutputter
    FileOutputter.expects(:new)
    log.logger
  end
  
  def test_logger_notifications
    log = Log.new

    # Log to stdout on warn level
    log.logger.expects(:warn).with("testing logger notifications")    
    log.notify("testing logger notifications")
  end
end