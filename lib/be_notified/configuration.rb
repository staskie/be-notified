require 'json'

module BeNotified
  module Configuration
    
    CONFIG_FILE = "#{ENV['HOME']}/.be_notified"
    
    # Singleton storing configuration for this library
    class << self
      # Main configuration method. It merges default configuration and properties
      # read from the configuration file. Then it does basic validation
      #
      # Returns Hash with options
      def options
        @options ||= begin
          opts = default_options.merge!(config_file_options)
          raise ArgumentError, "Invalid configuration options for emails #{opts}" if ! email_options_valid?(opts)
          opts
        end
      end
      
      # Set of default options
      #
      # Returns Hash with default options
      def default_options
        {
          :notifier_type  => BeNotified::Notifiers::Log,
          :email          => Hash.new { |k,h| k[h] = {}}
        }
      end
         
      # Read configuration from the file.
      #
      # Returns options in JSON format if everything goes fine
      # Returns empty string in case of error
      def load_config_file
        File.open(CONFIG_FILE).read
      rescue Errno::ENOENT
        ""
      end
      
      # Parse options from configuration file
      #
      # Returns hash with options
      # Returns empty hash in case of parse exception
      # Returns empty hash if there were problems with reading the file
      def config_file_options
        # Make sure that keys are symbols
        opts = load_config_file
        opts == "" ? {} : JSON.parse(opts).symbolize_keys!        
        
      rescue JSON::ParserError => e
        puts "Error while parsing the configuration file: #{e.message}"
        {}
      end
      
      # Validate email properties
      #
      # opts - Hash with options
      #
      # Returns true if all options exists and are not empty
      # Returns true if notifier_type is pointing to use emails
      def email_options_valid?(opts)
        # We don't really care about email validation if not using emails for notifications
        return true if ! email_notifier?(opts)

        opts[:email].symbolize_keys!
        opts[:email].key?(:smtp_address) && opts[:email][:smtp_address] != "" &&
        opts[:email].key?(:smtp_port)    && opts[:email][:smtp_port] != "" &&
        opts[:email].key?(:domain)       && opts[:email][:domain] != "" &&
        opts[:email].key?(:username)     && opts[:email][:username] != "" &&
        opts[:email].key?(:password)     && opts[:email][:password] != "" &&
        opts[:email].key?(:to)           && opts[:email][:to] != "" &&
        opts[:email].key?(:from)         && opts[:email][:from] != "" &&
        opts[:email].key?(:subject)      && opts[:email][:subject] != "" 
      end
      
      # When we parse configuration file, notifier_type is a String
      # However, when we define them in the code, usually we use a class type
      def email_notifier?(opts)
        opts[:notifier_type] == BeNotified::Notifiers::Email || opts[:notifier_type] == "BeNotified::Notifiers::Email"
      end
    end
    
    # Easier and nicer? way for classes that include this module
    # to access the configuration options
    def options
      Configuration.options
    end
  end
end
