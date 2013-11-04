require 'yaml'
require File.join(File.expand_path(File.dirname(__FILE__)), 'lib/parser')

def parse(str)
	output = Parser.new.parse str
	puts output.to_yaml
rescue Parslet::ParseFailed => failure
	puts failure.cause.ascii_tree
end

parse "x = 1 + 3"