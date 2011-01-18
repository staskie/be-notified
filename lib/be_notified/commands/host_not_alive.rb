require 'socket'

module BeNotified
  module Commands
    
    # Check if a given host is up
    #
    # host - The String represending either the domain name or IP address
    # packets - number of PING packets to send to the host
    #
    # For example:
    #   host_not_alive?("example.com", 10)
    #
    # Returns true if no response from host
    # Returns false if there was a response from host
    def host_not_alive?(host, packets=5)
      command = "ping -c #{packets} #{host}"
      
      run_system(command) !~ /64 bytes from/
    end
    
    private
    
    # For stubbing
    def run_system(command)
      `#{command}`
    end
  end
end