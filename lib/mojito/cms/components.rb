# encoding: UTF-8

module Mojito
	
	module CMS
		
		class Component
			include Mongoid::Document
			include Mongoid::Timestamps
			
			belongs_to :parent, class_name: 'Mojito::CMS::Area'
			
			def to_s
				"#{self.class.name}: #{id}"
			end
			
		end
		
		class Area
			include Mongoid::Document
			
			embedded_in :container, inverse_of: :areas
			field :name, type: String
			
			has_many :components, inverse_of: :parent
			
			def traverse(depth = 0, &visitor)
				visitor.call self, depth
				components.each do |cmp|
					if cmp.respond_to? :traverse
						cmp.traverse depth + 1, &visitor
					else
						visitor.call cmp, depth + 1
					end
				end
				self
			end
			
			def to_s
				"#{container.class.name} #{container.id}: #{name}"
			end
			
		end
		
		class Container < Component
			
			embeds_many :areas
			
			class <<self
				
				def area(name, &block)
					class_eval <<-EVAL
					def #{name}
						areas.where(:name => '#{name}').first || Area.create(:container => self, :name => '#{name}')
					end
					EVAL
				end
				
			end
			
			def traverse(depth = 0, &visitor)
				visitor.call self, depth
				areas.each do |area|
					area.traverse depth + 1, &visitor
				end
				self
			end
			
			def to_s
				"#{self.class.name}: #{id}"
			end
			
		end
		
		class Page < Container
			
			field :name, type: String
			field :title, type: String
			
		end
		
	end
	
end