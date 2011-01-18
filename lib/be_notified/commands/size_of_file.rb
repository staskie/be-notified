module BeNotified
  module Commands
    # Extend Fixnum class and add some handy methods
    # 
    # For example:
    #   size_of_file('file.log') > 4.MB
    class ::Fixnum
      def KB
        self * 1000
      end
      
      def MB
         self * 1000 * 1000
      end
      
      def GB
        self * 1000 * 1000 * 1000
      end
    end
    # Get size of the file
    #
    # file - The String with file name
    # 
    # For example:
    #
    #   size_of_file('abc.txt')
    #
    # Returns Integer value, size of the file
    def size_of_file(file)
      raise ArgumentError if ! File.exists?(file)
      File.size(file)
    end
  end
end