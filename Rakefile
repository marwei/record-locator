# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "record-locator"
  gem.homepage = "http://github.com/VenueDriver/record-locator"
  gem.license = "MIT"
  gem.summary = %Q{Use Base-27 encoding to shorten ID strings for easier data entry.}
  gem.description = %Q{A Base-36 encoding for integer database IDs without potentially confusing character pairs like 5 and S, B and 8, I and 1, O and 0, or Q}
  gem.email = "rap@endymion.com"
  gem.authors = ["Abdul Barek", "Ryan Alyn Porter"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "record-locator #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new('spec')