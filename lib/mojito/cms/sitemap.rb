# encoding: UTF-8

module Mojito::CMS
	
	class NavigationNode
		include Mongoid::Document
		
		belongs_to :parent, class_name: 'Mojito::CMS::NavigationNode', inverse_of: :children
		has_many :children, class_name: 'Mojito::CMS::NavigationNode', inverse_of: :parent
		
		field :name, type: String
		field :path, type: String
		
		belongs_to :page
		field :reference, type: String
		
		before_save do
			self.path = self.parent ? self.parent.path / self.name : '/'
		end
		
		def traverse(depth = 0, &visitor)
			visitor.call self, depth
			children.each do |node|
				node.traverse depth + 1, &visitor
			end
			self
		end
		
		def to_s
			(children.empty? ? '- ' : '+ ') + "#{name}"
		end
		
	end
	
	class Page
		
		has_many :navigation_nodes
		
	end
	
end