# encoding: UTF-8

module Mojito::CMS
	
	module RenderingController
		
		def self.included(type)
			type.extend ClassMethods
		end
		
		def render(component)
			if renderers = self.class.renderers[component.class]
				ext = (@cms_extension || :html).to_sym
				renderer = renderers[ext]
				if renderer
					instance_exec component, &renderer
				elsif component.respond_to?("to_#{ext.to_s}".to_sym)
					component.send "to_#{ext.to_s}".to_sym
				end
			end
		end
		
		def mount_navigation(menu_name)
			/^(?<path>.+?)(?:\.(?<extension>[^.]+))?(?:$|\?)/ =~ request.path_info
			@cms_path = path
			@cms_extension = extension
			node = Mojito::CMS::NavigationNode.where(menu_name: menu_name, path: path).first
			if node and page = node.page
				write render(page)
				ok!
			elsif reference = node.reference
				redirect! reference
			else
				not_found!
			end
			internal_server_error!
		end
		
		module ClassMethods
			
			def rendering(component, options = {}, &block)
				r = Renderer.new component, options, &block
				renderers[component] ||= {}
				renderers[component][options[:as].to_sym] = block
			end
			
			def renderers
				@renderers ||= {}
			end
			
		end
		
		class Renderer
			
			def initialize(component, options = {}, &block)
				@component = component
				@options = options
				@block = block
			end
			
			attr_reader :component, :block
			
			def as
				(@options[:as] || :html).to_sym
			end
			
			def match?(request, response)
				
			end
			
		end
		
	end
	
end