require 'test_helper'


class TestEmailNotifier < Test::Unit::TestCase
  include BeNotified::Notifiers
  
  def setup
    email_options = {
      :email => {
        :smtp_address => 'localhost',
        :smtp_port    => 25,
        :domain       => 'example.com',
        :username     => 'login',
        :password     => 'pass',
        :to           => 'to@example.com',
        :from         => 'from@example.com',
        :subject      => 'The Subject'
      }
    }
    
    # Make sure we always start fresh
    BeNotified::Configuration.instance_variable_set(:@options, nil)

    # In most cases pretend that configuration file does not exists
    BeNotified::Configuration.stubs(:load_config_file).returns("")
    
    # Merge email_options
    BeNotified::Configuration.stubs(:config_file_options).returns(email_options)
  end
  
  def test_configuration_access
    assert Email.new.respond_to? :options
  end
  
  def test_notifier_type_before_using_email
    BeNotified::Configuration.options.merge!({:notifier_type => BeNotified::Notifiers::Log})
    
    assert_raise ArgumentError do
      Email.new.notify("Trying to send an email")
    end
  end
  
  # Test sending email
  def test_sending_email
    BeNotified::Configuration.options.merge!({:notifier_type => BeNotified::Notifiers::Email})
    
    sender = mock(:deliver)
    Email::Mailer.expects(:email).returns(sender)
    
    Email.new.notify("sending emails works fine")
  end
end