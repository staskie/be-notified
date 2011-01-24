require 'test_helper'

class TestNotifier < Test::Unit::TestCase
  include BeNotified
  
  def test_notifier_sending_messages_to_log
    Notifiers::Log.any_instance.expects(:notify).with("test log notifier")
    Notifier.new(Notifiers::Log, "test log notifier").notify
  end
  
  def test_notifier_sending_messages_to_email
    Notifiers::Email.any_instance.expects(:notify).with("test email notifier")
    Notifier.new(Notifiers::Email, "test email notifier").notify
  end
  
  def test_notifier_sending_messages_to_email_for_string_type_of_notifier
    Notifiers::Email.any_instance.expects(:notify).with("test email notifier")
    Notifier.new("Notifiers::Email", "test email notifier").notify
  end
  
  def test_multiple_notifiers
      Notifiers::Log.any_instance.expects(:notify).with("Test multiple notifiers")
      Notifiers::Email.any_instance.expects(:notify).with("Test multiple notifiers")
      Notifier.new(["BeNotified::Notifiers::Log", "BeNotified::Notifiers::Email"], "Test multiple notifiers").notify
  end
end