# encoding: UTF-8

module Mojito::CMS
	
	class Delivery
		include Mojito
		controller :runtime
		rendering :all
			
		routes do
				
			on GET() do
				node = Mojito::CMS::NavigationNode.where(path: request.path_info).first
				if page = node.page
					write page.title
					
					ok!
				elsif reference = node.reference
					redirect! reference
				else
					not_found!
				end
			end
				
		end
			
	end
	
end