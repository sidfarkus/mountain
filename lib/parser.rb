require 'parslet'

class Parser < Parslet::Parser
  # Helper rules for spaces between things
  rule(:spaces) { match('\s').repeat(1) }
  rule(:spaces?) { spaces.maybe }
  rule(:newline) { match('\n') }

  # Define matchers for the base literals
  rule(:fixnum) { match['-'].maybe >> match['1-9'] >> match['0-9'].repeat }
  rule(:float) { match['-'].maybe >> ((match['1-9'].maybe >> match['\.'] >> match['0-9'].repeat) | (match['1-9'].repeat(1) >> match['e'] >> match['0-9'].repeat)) }
  rule(:string) do
    (match['"'] >> match['^"'].repeat >> match['"']) |
    (match["'"] >> match["^'"].repeat >> match["'"])
  end

  rule(:numeric) { fixnum.as(:fixnum) | float.as(:float) }
  rule(:literal) { numeric | string.as(:string) }

  # Identifiers are named references to things -- classes, functions, modules etc
  rule(:identifier) do
    match['a-zA-Z0-9_'].repeat(1)
  end

  rule(:bit) do
    literal | identifier.as(:identifier)
  end

  def operator(symbol)
    bit.as(:lhs) >> spaces? >> match[symbol].as(:op) >> spaces? >> (bit | expression).as(:rhs)
  end

  def grouped(atom)
    match['('] >> spaces? >> atom >> spaces? >> match[')']
  end

  rule(:addition) { operator '+' }
  rule(:subtraction) { operator '-' }
  rule(:multiplication) { operator '*' }
  rule(:division) { operator '/' }
  rule(:assignment) { operator '=' }

  # No statements! Only expressions.
  rule(:expression) do
    math = (multiplication | division | addition | subtraction)
    math | assignment | grouped(expression) 
  end

  rule(:arg_list) do
    identifier | ((identifier >> spaces? >> match[','] >> spaces?).repeat >> identifier)
  end

  # Functions start with def
  rule(:function) do
    str('def') >> spaces? >> identifier >> spaces? >> (spaces >> arg_list >> spaces).maybe >> newline >> \
    (expression >> spaces).repeat >> newline >> \
    spaces? >> str('end')
  end

  root(:expression)
end