module BeNotified
  module Commands
    
    # Check number of files in a given folder
    #
    # directory - The String representing the name of the directory
    # mask - Regexp to match the files
    #
    # For example:
    #
    #   number_of_files("/var/log")
    #   number_of_files("/var/log", /\.log$/)
    #
    # Returns Integer, count of files in a directory
    def number_of_files(directory, mask = nil)
      raise ArgumentError, "Directory '#{directory}' not found" if ! File.exists?(directory)
      raise ArgumentError, "Mask should be a Regexp"            if ! mask.nil? && ! (mask.kind_of? Regexp)
      
      count = 0
      Dir.glob("#{directory}/*").each do |file|
        next if ! File.file?(file)
        
        if mask.nil?
          count += 1
        else
          count += 1 if file =~ Regexp.new(mask)
        end
      end
      
      count
    end
  end
end