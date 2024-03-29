# encoding: UTF-8

require 'mojito/cms'
include Mojito::CMS
Mongoid.load! 'database.yml', :development

class PlainText < Mojito::CMS::Component
	
	field :text, type: String
	
end

class TwoColumns < Mojito::CMS::Container
	
	area :left
	area :right
	
end

class LandingPage < Mojito::CMS::Page
	
	area :center
	area :sidebar
	
end

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
	
	rendering Mojito::CMS::Page, as: :json do |page|
		write page.to_json
	end
	
	rendering PlainText, as: :html do |cmp|
		template 'simple_plain_text.html.erb', cmp: cmp
	end

	rendering TwoColumns, as: :html do |cmp|
		template 'simple_two_columns.html.erb', cmp: cmp
	end

	rendering LandingPage, as: :html do |cmp|
		template 'simple_landing_page.html.erb', cmp: cmp
	end

end

def generate_test_content
	
	lp1 = LandingPage.create title: 'Landing Page'
	lp1.center.components << tc = TwoColumns.create
	tc.left.components << PlainText.create(text: 'Hello World 1')
	tc.left.components << PlainText.create(text: 'Hello World 2')
	tc.right.components << PlainText.create(text: 'Hello World 3')
	tc.right.components << PlainText.create(text: 'Hello World 4')
	
	root = NavigationNode.create menu_name: 'main', page: lp1
	NavigationNode.create parent: root, name: 'index', page: lp1
	NavigationNode.create parent: root, name: 'projects'
	
	lp1
end
