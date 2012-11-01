$: << './lib'
require 'mojito/cms'
# encoding: utf-8

require 'rubygems'
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
	gem.name = "mojito-cms"
	gem.homepage = "http://github.com/mtrense/mojito-cms"
	gem.license = "MIT"
	gem.summary = %Q{CMS ontop of mojito}
	gem.description = %Q{Component-based content management system build ontop of mojito.}
	gem.email = "dev@trense.info"
	gem.authors = ["Max Trense"]
	gem.files = FileList[%W{lib/**/*.rb spec/**/*_spec.rb README.* LICENSE.*}]
	gem.add_dependency 'mojito', '~> 0.3'
	gem.add_dependency 'extlib', '~> 0.9.15'
	gem.add_dependency 'mongoid', '~> 3.0.9'
	gem.add_dependency 'mongoid-tree', '~> 1.0.1'
	gem.add_development_dependency "rspec", "~> 2.8.0"
	gem.add_development_dependency "rdoc", "~> 3.12"
	gem.add_development_dependency "jeweler", "~> 1.8.4"
	gem.add_development_dependency "rcov", ">= 0"
end
Jeweler::RubygemsDotOrgTasks.new

task :generate_test_content do
	Mongoid.load! 'database.yml', :development
	require './sample/simple'
	before = [Mojito::CMS::Component.count, Mojito::CMS::NavigationNode.count]
	generate_test_content
	after = [Mojito::CMS::Component.count, Mojito::CMS::NavigationNode.count]
	puts "Generated #{after[0] - before[0]} components"
	puts "Generated #{after[1] - before[1]} navigation-nodes"
end

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
	spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
	spec.pattern = 'spec/**/*_spec.rb'
	spec.rcov = true
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
	version = File.exist?('VERSION') ? File.read('VERSION') : ""

	rdoc.rdoc_dir = 'rdoc'
	rdoc.title = "mjt-dojo #{version}"
	rdoc.rdoc_files.include('README*')
	rdoc.rdoc_files.include('lib/**/*.rb')
end
