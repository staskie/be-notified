# BeNotified
## Description

This library monitors your programs or resources and notifies you by email or log if anything goes wrong.

## Installation

This gem is hosted on gemcutter.org

	gem install be-notified

## Usage

	require 'be_notified'

	BeNotified::Monitor.new do
		alert_when "Something went wrong" do
			# Put your code here 
			# Return true if something went wrong 
			# or false if everything was fine
		end
	end


This library can be used in two different ways:

__First:__ Run it from crontab to monitor some resources, for exmaple:

	BeNotified::Monitor.new do
		alert_when "Staging server is down" do
			host_not_available?("staging.example.com")
		end
	end

or


	BeNotified::Monitor.new do
		alert_when "Log file does not exist" do
			File.exists?('/var/log/messages') == false
		end
	end
	

__Second:__ Wrap your program around it and be informed when something goes wrong. I will use imaginary program called db_updater as an example:

	BeNotified::Monitor.new do
		alert_when "Db was not updated" do
			# Require your program here
			require 'db_updater'
		
			# Get the count of the records before run
			count_before_run = DBUpdater::Update::Record.all.count
		
			# Run your application
			DBUpdater::Update.run
		
			# Get the count after the run
			count_after_run = DBUpdater::Update::Record.all.count
		
			# Now decide if anything went wrong
			count_after_run == count_before_run
		end
	end

## Configuration file

Options can be set up in the three different ways:

__First:__ By default program will log to standard output.

__Second:__ Define properties directly in the code. An example of setting logging and email notification:

	BeNotified::Monitor.new do
		custom_options = {
			:notifier_type  => [BeNotified::Notifiers::Log, BeNotified::Notifiers::Email]
	    :email => {
	      :smtp_address => 'localhost',
	      :smtp_port    => 25,
	      :domain       => 'example.com',
	      :username     => 'login',
	      :password     => 'pass',
	      :to           => 'to@example.com',
	      :from         => 'from@example.com',
	      :subject      => 'The Subject'
	    }
	  }

		# Make sure you merge the options
		configuration(custom_options)
	end

__Third:__ Create a file _.be\_notified_ in your home directory. It stores the configuration in JSON format. An example of setting application to log to the file:

	{"logger_file":"/tmp/benotified.log"}

# Helper Methods

This library is shipped with some helper methods that can be used to monitor resources:

* host\_not\_alive? - checks if a given host if alive or not
	
		alert_when "Staging server is down" do
			host_not_available?("staging.example.com")
		end

* number\_of\_files - checks the number of files in a given directory

		alert_when "Number of files on the desktop is greater then 50" do
			number_of_files("/Users/dominik/Desktop") > 50
		end
	
* program\_running? - checks if a given program is running

		alert_when "Application server is not running" do
			! program_running?("jboss")
		end
	
* size\_of\_file - checks the size of a given file in GB, MB or KB

		alert_when "JBoss log file is bigger then 1GB" do
			size_of_file("/usr/local/jboss/server/default/log/server.log") > 1.GB
		end

# How to contribute

1. Revise the code and suggest improvements / changes
2. Write more helper methods
3. Add new ways of notifying user



