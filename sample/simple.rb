# encoding: UTF-8

require 'mojito/cms'
include Mojito::CMS
Mongoid.load! 'database.yml', :development

class PlainText < Mojito::CMS::Component
	
	field :text, type: String
	
end

Mojito::CMS::Delivery.rendering PlainText, as: :html do |cmp|
	template 'simple_plain_text.html.erb', cmp: cmp
end

class TwoColumns < Mojito::CMS::Container
	
	area :left
	area :right
	
end

Mojito::CMS::Delivery.rendering TwoColumns, as: :html do |cmp|
	template 'simple_two_columns.html.erb', cmp: cmp
end

class LandingPage < Mojito::CMS::Page
	
	area :center
	area :sidebar
	
end

Mojito::CMS::Delivery.rendering LandingPage, as: :html do |cmp|
	content_type :html
	template 'simple_landing_page.html.erb', cmp: cmp
end

def generate_test_content
	
	lp1 = LandingPage.create title: 'Landing Page'
	lp1.center.components << tc = TwoColumns.create
	tc.left.components << PlainText.create(text: 'Hello World 1')
	tc.left.components << PlainText.create(text: 'Hello World 2')
	tc.right.components << PlainText.create(text: 'Hello World 3')
	tc.right.components << PlainText.create(text: 'Hello World 4')
	
	root = NavigationNode.create name: 'main', page: lp1
	root.children << NavigationNode.create(name: 'index', page: lp1)
	root.children << NavigationNode.create(name: 'projects')
	
	lp1
end
