# encoding: UTF-8

module Mojito::CMS
	
	class NavigationNode
		include Mongoid::Document
		include Mongoid::Tree
		include Mongoid::Tree::Ordering
		
		field :name, type: String
		field :menu_name, type: String
		field :path, type: String
		
		belongs_to :page
		field :reference, type: String
		
		after_rearrange do
			self.menu_name = self.root.menu_name
			self.path = self.ancestors_and_self.collect(&:name).join('/')
		end
		
		def traverse(depth = 0, &visitor)
			visitor.call self, depth
			children.each do |node|
				node.traverse depth + 1, &visitor
			end
			self
		end
		
		before_destroy :destroy_children
		
		def to_s
			(leaf? ? '- ' : '+ ') + "#{name}"
		end
		
	end
	
	class Page
		
		has_many :navigation_nodes
		
	end
	
end