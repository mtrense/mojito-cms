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
			self.menu_name = self.parent ? self.parent.menu_name : self.name
			self.path = self.parent ? self.parent.path / self.name : '/'
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