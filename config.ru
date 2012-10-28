$: << './lib'
require 'mojito/cms'

Mongoid.load! 'database.yml'

require './sample/simple'

class Delivery
	include Mojito
	controller :runtime
	rendering :all
		
	include Mojito::CMS::RenderingController
		
	routes do
				
		on GET() do
			mount_navigation 'main'
		end
				
	end
			
end

run Delivery