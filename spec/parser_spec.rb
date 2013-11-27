require 'parser'
require 'parslet/rig/rspec'

describe Parser do
	subject(:parser) { Parser.new }

	context 'literals' do
		context 'fixnum' do
			it 'does not parse numbers starting with zero' do
				parser.fixnum.should_not parse('01234')
			end

			it 'parses only numbers' do
				parser.fixnum.should_not parse('1234F')
			end
		end

		context 'string' do
			it 'parses anything surrounded by double quotes' do
				parser.string.should parse('"anything +-!@#(*&%@(#&*9812365490`\'"')
			end

			it 'parses anything surrounded by single quotes' do
				parser.string.should parse("'anything +-@#$*(&(#*$&@(#$98))}\"'")
			end

			it 'allows escaped double quotes using backslash within double quotes' do
				parser.string.should parse('"\\""')
			end

			it 'allows escaped single quotes using backslash within single quotes' do
				parser.string.should parse("'\\''")
			end

			it 'allows interpolation using #{} syntax in double quotes' do
				parser.string.parse('"#{fizz}"')
			end

			it 'does not allow interpolation in single quoted strings' do
				parser.string.parse("'\#{fizz}'")
			end
		end

		context 'bool' do
			it 'parses the identifier true' do
				parser.bool.should parse('true')
			end

			it 'parses the identifier false' do
				parser.bool.should parse('false')
			end
		end

		context 'float' do
			it 'parses a float with a leading zero and digits after the point' do
				parser.float.should parse('0.1')
			end

			it 'does not require anything after the decimal point' do
				parser.float.should parse('1234.')
			end

			it 'parses negative numbers' do
				parser.float.should parse('-1.5')
			end

			it 'parses a float in exponential notation' do
				parser.float.should parse('1.4e10')
			end

			it 'parses negative exponential floats' do
				parser.float.should parse('-48.33e21')
			end
			
			it 'parses exponential floats with negative exponents' do
				parser.float.should parse('-2.1e-15')
			end			

			it 'does not parse a leading zero with a whole part after it' do
				parser.float.should_not parse('01.2')
			end
		end
	end
end