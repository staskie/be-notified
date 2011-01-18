$:.push File.join(File.dirname(__FILE__), "../lib")

require 'be_notified'


BeNotified::Monitor.new do
  options = {
      :notifier_type => BeNotified::Notifiers::Email,
      :email => {
        :smtp_address => 'smtp.gmail.com',
        :smtp_port    => 587,
        :domain       => 'gmail.com',
        :username     => 'login',
        :password     => 'password',
        :to           => 'to@email',
        :from         => 'from@email',
        :subject      => 'We have a problem'
      }
    }
  
  configuration(options)
  
  alert_when "number of files is greater then 5" do
    number_of_files("/Users/dominik/Desktop") > 5
  end
  
  alert_when "number of jpg files is greater then 2" do
    number_of_files("/Users/dominik/Desktop", /jpg/i) > 2
  end
  
  alert_when "size of abc.txt if greater then 4" do
    size_of_file("/Users/dominik/Desktop/abc.txt") > 4
  end
  
  alert_when "Dock process is running" do
    program_running?('dock')
  end
  
  alert_when "Java prociess is not running" do
    program_not_running?('java')
  end
  
  alert_when "Staging server is down" do
    host_not_alive?("192.168.1.2", 2)
  end
end