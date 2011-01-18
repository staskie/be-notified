module BeNotified
  module Commands
    # Hook method called when this module is included by some other class
    # It loads all the command helpers
    def self.included(base)
      dir = File.join(File.dirname(__FILE__), 'commands')
      
      Dir.glob("#{dir}/*.rb").each do |command|
        require command
      end
    end
  end
end