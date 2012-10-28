$: << './lib'
require 'mojito/cms'

task :generate_test_content do
	Mongoid.load! 'database.yml', :development
	require './sample/simple'
	before = [Mojito::CMS::Component.count, Mojito::CMS::NavigationNode.count]
	generate_test_content
	after = [Mojito::CMS::Component.count, Mojito::CMS::NavigationNode.count]
	puts "Generated #{after[0] - before[0]} components"
	puts "Generated #{after[1] - before[1]} navigation-nodes"
end
