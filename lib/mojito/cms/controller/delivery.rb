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
			case component
			when Area
				"<div class=\"area #{component.name}\" id=\"#{component.container.id}-#{component.name}\">\n#{component.components.collect {|c| render c }.join("\n")}\n</div>"
			when Component
				if renderers = self.class.renderers[component.class]
					ext = (@cms_extension || :html).to_sym
					renderer = self.class.renderer_for component.class, ext
					case component
					when Page
						content_type ext
						if renderer
							instance_exec component, &renderer
						elsif component.respond_to?("to_#{ext.to_s}".to_sym)
							component.send "to_#{ext.to_s}".to_sym
						end
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
			
			def rendering(component_type, options = {}, &block)
				extension = options[:as]
				renderers[component_type] ||= {}
				renderers[component_type][extension.to_sym] = block
			end
			
			def renderers
				@renderers ||= {}
			end
			
			def renderer_for(component_type, extension = :html)
				if renderers[component_type] and renderers[component_type][extension.to_sym]
					renderers[component_type][extension.to_sym]
				elsif component_type.superclass
					renderer_for component_type.superclass, extension
				else
					nil
				end
			end
			
		end
		
	end
	
end