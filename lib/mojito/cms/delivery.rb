# encoding: UTF-8

module Mojito::CMS
	
	##
	# Includes several utility-methods to access and render content as defined in Mojito::CMS.
	module RenderingController
		
		def self.included(type)
			type.extend ClassMethods
		end
		
		##
		# Render a component within the current context (which may be within another component)
		# Provides access to the given component via current_component().
		def render(component)
			if renderers = self.class.renderers[component.class]
				ext = (@cms_extension || :html).to_sym
				renderer = renderers[ext]
				case component
				when Page
					result = if renderer
						instance_exec component, &renderer
					elsif component.respond_to?("to_#{ext.to_s}".to_sym)
						component.send "to_#{ext.to_s}".to_sym
					end
				when Area
					
				when Component
					components.push component
					result = if renderer
						instance_exec component, &renderer
					elsif component.respond_to?("to_#{ext.to_s}".to_sym)
						component.send "to_#{ext.to_s}".to_sym
					end
					components.pop
					result
				end
			end
		end
		
		##
		# Mounts the NavigationNode accessed by menu_name at the current URI. Called from the controller
		# to delegate content-dispatching based on path to the given NavigationNode.
		def mount_navigation(menu_name)
			/^(?<path>.+?)(?:\.(?<extension>[^.]+))?(?:$|\?)/ =~ request.path_info
			@cms_path = path
			@cms_extension = extension
			@navigation = Mojito::CMS::NavigationNode.where(menu_name: menu_name, path: path).first
			if @navigation
				if page = @navigation.page
					write render(page)
					ok!
				elsif reference = @navigation.reference
					redirect! reference
				else
					not_found!
				end
			else
				not_found!
			end
			internal_server_error!
		end
		
		##
		# Returns the current NavigationNode or nil
		def navigation
			@navigation
		end
		
		##
		# Returns the page associated to the current NavigationNode or nil
		def page
			@navigation ? @navigation.page : nil
		end
		
		##
		# Returns a stack of components currently rendered. The first component (most often the page) 
		# is at components.first, the one currently rendered is at components.last.
		def components
			@components ||= []
		end
		
		##
		# Returns the current component or nil if no component is rendered currently
		def current_component
			components.last
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