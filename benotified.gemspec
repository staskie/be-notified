# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{benotified}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dominik Staskiewicz"]
  s.cert_chain = ["/Users/dominik/Documents/keys/gem-public_cert.pem"]
  s.date = %q{2011-01-19}
  s.description = %q{Library to monitor your programs and resources. It will notify you by email or just log the event if something goes wrong.}
  s.email = %q{stadominik @nospam@ gmail.com}
  s.extra_rdoc_files = ["README.md", "lib/be_notified.rb", "lib/be_notified/commands.rb", "lib/be_notified/commands/host_not_alive.rb", "lib/be_notified/commands/number_of_files.rb", "lib/be_notified/commands/program_running.rb", "lib/be_notified/commands/size_of_file.rb", "lib/be_notified/configuration.rb", "lib/be_notified/monitor.rb", "lib/be_notified/notifier.rb", "lib/be_notified/version.rb", "lib/benotified.rb"]
  s.files = ["Gemfile", "Gemfile.lock", "Manifest", "README.md", "Rakefile", "benotified.gemspec", "examples/monitor.rb", "lib/be_notified.rb", "lib/be_notified/commands.rb", "lib/be_notified/commands/host_not_alive.rb", "lib/be_notified/commands/number_of_files.rb", "lib/be_notified/commands/program_running.rb", "lib/be_notified/commands/size_of_file.rb", "lib/be_notified/configuration.rb", "lib/be_notified/monitor.rb", "lib/be_notified/notifier.rb", "lib/be_notified/version.rb", "lib/benotified.rb", "test/commands/test_host_not_alive.rb", "test/commands/test_number_of_files.rb", "test/commands/test_program_running.rb", "test/commands/test_size_of_file.rb", "test/notifiers/test_email_notifier.rb", "test/notifiers/test_log_notifier.rb", "test/test_configuration.rb", "test/test_helper.rb", "test/test_monitor.rb", "test/test_notifier.rb"]
  s.homepage = %q{http://github.com/staskie/be-notified}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Benotified", "--main", "README.md"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{benotified}
  s.rubygems_version = %q{1.3.7}
  s.signing_key = %q{/Users/dominik/Documents/keys/gem-private_key.pem}
  s.summary = %q{Library to monitor your programs and resources. It will notify you by email or just log the event if something goes wrong.}
  s.test_files = ["test/commands/test_host_not_alive.rb", "test/commands/test_number_of_files.rb", "test/commands/test_program_running.rb", "test/commands/test_size_of_file.rb", "test/notifiers/test_email_notifier.rb", "test/notifiers/test_log_notifier.rb", "test/test_configuration.rb", "test/test_helper.rb", "test/test_monitor.rb", "test/test_notifier.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
