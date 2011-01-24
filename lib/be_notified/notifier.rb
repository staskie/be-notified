require 'log4r' 
require 'action_mailer'

module BeNotified
  # Delegate notification to other classes
  class Notifier
    # Initializer requires two arguments:
    #
    #  notifier_types - String, Class or Array represending notifiers, can be:
    #                     BeNotified::Notifiers::Log (default)
    #                     BeNotified::Notifiers::Email
    #                     [BeNotified::Notifiers::Log, BeNotified::Notifiers::Email]
    #  message - The String, message send to the user
    def initialize(notifier_types, message)
      @notifier_types = notifier_types
      @message  = message
    end
    
    # This method will actually inform the user about the problem
    #
    # message - The String with the message that should be passed to user
    #
    # For example:
    #   notify("Server is down")
    #
    # Returns nothing
    def notify
      notifiers.each do |notifier|
        notifier.notify(@message)
      end
    end
    
    private
    
    def notifiers
      notifiers = []
      
      if @notifier_types.kind_of? Array
        @notifier_types.each do |notifier|
          notifiers << get_notifier_type(notifier)
        end
      else
        notifiers << get_notifier_type(@notifier_types)
      end
      
      notifiers
    end
    
    def get_notifier_type(notifier_type)
      notifier_type.class ===  "String" ? eval("#{notifier_type}.new") : notifier_type.new
    end
  end
  

  module Notifiers
    
    # This class will send notifications by email. 
    # It is using ActionMailer >= 3.0.0
    class Email
      include BeNotified::Configuration
      
      # Delegated method from BeNotified::Notifier class
      def notify(message)
        raise ArgumentError, "You can't use Email notification when Log is set in your configuration" if options[:notifier_type] == BeNotified::Notifiers::Log
        Mailer.logger = Logger.new(STDOUT)
        
        Mailer.smtp_settings = {
          :address              => options[:email][:smtp_address],
          :port                 => options[:email][:smtp_port].to_i,
          :domain               => options[:email][:domain],
          :user_name            => options[:email][:username],
          :password             => options[:email][:password],
          :authentication       => 'plain',
          :enable_starttls_auto => true  }
        
        Mailer.email(message, options).deliver
      end
    
      # Inner class responsible for sending emails
      class Mailer < ActionMailer::Base
        
        def email(message, options)
          mail_options = {
            :to       => options[:email][:to],
            :from     => options[:email][:from],
            :subject  => options[:email][:subject]            
          }
          
          mail(mail_options) do |format|
            # Create the body of the message
            format.text { render :text => "#{message}"}
          end
        end
      end
    end
    
    # This class will notify the user by writing the message to log
    # Requires Log4r in any version
    class Log
      include Log4r
      include BeNotified::Configuration
      
     # Delegated method from BeNotified::Notifier class
      def notify(message)
        logger.warn "#{message}"
      end
      
      # This method creates logger instance. Depending on configuration it will
      # either log to the STDOUT or to the log file.
      #
      # Returns instance of logger
      def logger
        @logger ||= begin
          
          logger = Logger.new 'notify_logger'
          outputter =  options[:logger_file].nil? ? Outputter.stdout 
                                    : FileOutputter.new('notify_logger', :filename => options[:logger_file]) 

          logger.outputters << outputter                          
          logger.level = Log4r::WARN
          
          logger
        end
      end
    end
  end
end