rootpath = File.join(File.dirname(__FILE__),'..')
require File.join(rootpath, 'lib/rosie/version')

Dir[File.join(rootpath, "lib/tasks/**/*.rake")].each { |ext| load ext } if defined?(Rake)

module Rosie
end

