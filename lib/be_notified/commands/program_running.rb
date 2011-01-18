module BeNotified
  module Commands
    
    # Check if process is running
    #
    # name - The String represending the name of the process
    #
    # For example:
    #
    #   program_running?('netcat')
    #
    # Returns true if process is running
    # Returns false if process is not running
    # Raises RuntimeError if on Windows platform
    def program_running?(name)
      raise RuntimeError if running_on_windows?
      
      command = "ps -ef | grep -i #{name} | grep -v grep"
      
      # Run the command and check response
      run_system(command) != ""
    end
    
    # Check if process is not running
    # Argument and example the same as above
    # 
    # Returns true if process is NOT running
    # Returns false if process is running
    # Raises RuntimeError if on Windows platform
    def program_not_running?(name)
      ! program_running?(name)
    end
    
    private
    
    # For stubbing
    def run_system(command)
      `#{command}`
    end
    
    # Check if on windows platform
    def running_on_windows?
      RUBY_PLATFORM =~ /mswin32/
    end
  end
end