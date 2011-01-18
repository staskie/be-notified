$:.push File.join(File.dirname(__FILE__), "../lib")

require 'be_notified'


BeNotified::Monitor.new do
  
  alert_when "Clean your desktop." do
    number_of_files("/Users/dominik/Desktop") > 5
  end
  
  alert_when "Number of jpg files on the desktop is greater then 2" do
    number_of_files("/Users/dominik/Desktop", /jpg/i) > 2
  end
  
  alert_when "Size of abc.txt if greater then 4 KB" do
    size_of_file("/Users/dominik/Desktop/abc.txt") > 4.KB
  end
  
  alert_when "Java prociess is not running" do
    program_not_running?('java')
  end
  
  alert_when "Staging server is down" do
    host_not_alive?("192.168.1.2", 2)
  end
end