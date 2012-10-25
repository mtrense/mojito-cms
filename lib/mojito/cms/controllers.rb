# encoding: UTF-8

module Mojito::CMS
	require 'mojito/cms/delivery'
	
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
	
end