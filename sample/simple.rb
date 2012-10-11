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

def generate_test_content
	
	lp1 = LandingPage.create title: 'Landing Page'
	lp1.center.components << tc = TwoColumns.create
	tc.left.components << PlainText.create(text: 'Hello World 1')
	tc.left.components << PlainText.create(text: 'Hello World 2')
	tc.right.components << PlainText.create(text: 'Hello World 3')
	tc.right.components << PlainText.create(text: 'Hello World 4')
	
	root = NavigationNode.create name: 'main', page: lp1
	root.children << NavigationNode.create(name: 'projects')
	
	lp1
end
