$: << './lib'
require 'mojito/cms'

Mongoid.load! 'database.yml'

require './sample/simple'

run Delivery