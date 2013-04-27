require File.join(File.expand_path(File.dirname(__FILE__)), 'lib/parser')

def parse(str)
	output = Parser.new.parse str
	puts output.inspect
rescue Parslet::ParseFailed => failure
	puts failure.cause.ascii_tree
end

parse 'x = x * 5'