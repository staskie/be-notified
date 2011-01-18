require 'test_helper'

class TestConfiguration < Test::Unit::TestCase
  include BeNotified
  
  def setup
    # Make sure we always start fresh
    Configuration.instance_variable_set(:@options, nil)

    # In most cases pretend that configuration file does not exists
    Configuration.stubs(:load_config_file).returns("")
  end
  
  def test_configuration_having_default_values
    assert_equal Notifiers::Log, Configuration.options[:notifier_type]
  end
    
  def test_adding_a_value_to_configuration_from_the_monitor
    monitor = BeNotified::Monitor.new do
      opts = {
        :test => 'test'
      }
      configuration(opts)
    end
    assert_equal 'test', BeNotified::Configuration.options[:test]
  end
  
  def test_overwriting_options_from_configuration
    Configuration.options.merge!({:logger_file => '/tmp/be_notified.log'})
    
    monitor = BeNotified::Monitor.new do
      opts = {
        :logger_file => 'test_file.log'
      }
      configuration(opts)
    end

    assert_equal 'test_file.log', BeNotified::Configuration.options[:logger_file]
    assert_equal 'test_file.log', monitor.options[:logger_file]
  end
  
  def test_options_for_email_should_be_stored_in_hash
    assert Configuration.options[:email].is_a? Hash
  end
  
  def test_loading_config_from_file
    # Unstub 'load_config_file'
    Mocha::Mockery.instance.stubba.unstub_all
    
    File.expects(:open).returns(mock(:read => json_file_content))
    assert_equal json_file_content, Configuration.load_config_file
  end
  
  def test_loading_config_for_non_existing_file
    # Unstub 'load_config_file'
    Mocha::Mockery.instance.stubba.unstub_all
    
    File.expects(:open).raises(Errno::ENOENT)
    assert_equal "", Configuration.load_config_file
  end
  
  def test_parsing_invalid_file
    Configuration.expects(:load_config_file).returns(json_file_content)
    Configuration.expects(:puts)
    
    JSON.expects(:parse).raises(JSON::ParserError)
    
    assert_equal Hash.new, Configuration.config_file_options
  end
  
  def test_pasring_valid_json_content
    Configuration.expects(:load_config_file).returns(json_file_content)
    
    opts = { :logger_file => "/tmp/be_notified.log" }
    assert_equal opts, Configuration.config_file_options
  end
  
  def test_merging_default_config_with_config_from_file
    Configuration.expects(:load_config_file).returns(json_file_content)
    assert_equal "/tmp/be_notified.log", Configuration.options[:logger_file]
  end
  
  def test_validation_of_emails_configuration
    Configuration.expects(:load_config_file).returns(json_incomplete_file_content_for_email_options)
    
    assert_raise ArgumentError do
      Configuration.options
    end
  end
  
  def test_validation_of_emails_options_should_not_happen_when_logger_used
    Configuration.expects(:load_config_file).returns(json_file_content_with_email_options_and_logger_notifier)
    
    assert_nothing_raised do
      Configuration.options
    end
  end
  
  private
  
  def json_file_content
    json_content = <<-END
{"logger_file":"/tmp/be_notified.log"}
END
  end
  
  def json_file_content_with_email_options
    json_content = <<-END
{"notifier_type":"BeNotified::Notifiers::Email","email":{"smtp_address":"localhost","smtp_port":25,"domain":"example.com","username":"login","password":"pass","to":"to@example.com","from":"from@example.com","subject":"The Subject"}}
END
  end
  
  def json_incomplete_file_content_for_email_options
    json_content = <<-END
{"notifier_type":"BeNotified::Notifiers::Email","email":{"smtp_address":"localhost","domain":"example.com","username":"login","password":"pass","to":"to@example.com","from":"from@example.com","subject":"The Subject"}}
END
  end

def json_file_content_with_email_options_and_logger_notifier
  json_content = <<-END
{"notifier_type":"BeNotified::Notifiers::Log","email":{"smtp_address":"localhost","domain":"example.com","username":"login","password":"pass","to":"to@example.com","from":"from@example.com","subject":"The Subject"}}
END
end


end