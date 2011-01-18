require 'be_notified/notifier'
require 'be_notified/commands'

module BeNotified
  class Monitor
    # Include all available commands and configuration
    include Commands    
    include Configuration
   
    def initialize(&block)
      # Provide a nice way of accessing methods in this class
      instance_eval(&block)
    end
    
    # Main method provided by the library
    # Will send the message to the user when block returns true
    # 
    # message - The String with the message send back to user
    # block   - Block with a THING to monitor
    #
    # For example:
    #
    #   alert_when("block returns true") { true }
    #   
    # Returns nothing.
    def alert_when(message, &block)
      if block.call == true
        notify(message)
      end
    end
    
    # Get notifier type form configuration
    def notifier_type
      options[:notifier_type]
    end
    
    # It is possible to define some configuraiton options
    # directly in the code (besides configuration file)
    #
    # opts - The Hash with options. Currently available:
    #                  {
    #                    :logger_file    => Location of the file where application sends log
    #                    :notifier_type  => Notifier type. Currenty available: BeNotified::Notifiers::Log, BeNotified::Notifiers::Email
    #                    :email => {
    #                      :smtp_address => SMTP address
    #                      :smtp_port    => SMTP port
    #                      :domain       => Domain name, eg: example.com
    #                      :username     => Login
    #                      :password     => Password
    #                      :to           => Recipient
    #                      :from         => Sender
    #                      :subject      => Subject of the message
    #                    }
    #
    # For example:
    #   configuration({ :notifier_type => BeNotified::Notifiers::Email })
    #
    # Returns Hash, merged options from configuration file and defined in the class
    def configuration(opts)
      options.merge!(opts)
    end
    # Method responsible for notifing the user. Shouldn't be called directly
    # It gets notifier_type, creates a proper notifier and notifies the user
    # 
    # message - The String with the message send back to user
    #
    # For example:
    #
    #   notify("too many files in this directory")
    #
    # Returns nothing.
    def notify(message)
      notifier = BeNotified::Notifier.new(notifier_type, message)
      notifier.notify
    end
  end
end