require 'parslet'

class Parser < Parslet::Parser
  # Helper rules for spaces between things
  rule(:spaces) { match('\s').repeat(1) }
  rule(:spaces?) { spaces.maybe }
  rule(:newline) { match('\n') }

  # Define matchers for the base literals - FixNum, Float, String, Bool
  rule(:fixnum) { match['-'].maybe >> match['1-9'] >> match['0-9'].repeat }
  rule(:float) { match['-'].maybe >> ((match['1-9'].maybe >> match['\.'] >> match['0-9'].repeat) | (match['1-9'].repeat(1) >> match['e'] >> match['0-9'].repeat)) }
  rule(:bool) { str('true') | str('false') }  
  rule(:string) do
    interpolation = str('#{') >> expression >> match['}']
    escape = (match['\\\\'] >> match['nrt\\\\\'"']).as(:escaped)
    (match['"'] >> (interpolation.as(:interpolation) | escape | match['^"'].as(:content)).repeat >> match['"']) |
    (match["'"] >> (escape | match["^'"].as(:content)).repeat >> match["'"])
  end

  rule(:numeric) { fixnum.as(:fixnum) | float.as(:float) }
  rule(:literal) { numeric | string.as(:string) | bool.as(:bool) }

  # Identifiers are named references to things -- classes, functions, modules etc
  rule(:identifier) do
    match['a-zA-Z0-9_'].repeat(1).as(:identifier)
  end

  rule(:bit) do
    literal | identifier
  end

  def binary_operator(symbol)
    bit.as(:lhs) >> spaces? >> match[symbol].as(:op) >> spaces? >> expression.as(:rhs)
  end

  def unary_operator(symbol)
    match[symbol].as(:op) >> (bit | grouped(expression)).as(:target)
  end

  def grouped(atom)
    match['('] >> spaces? >> atom >> spaces? >> match[')']
  end

  rule(:negation) { unary_operator '-' }
  rule(:addition) { binary_operator '+' }
  rule(:subtraction) { binary_operator '-' }
  rule(:multiplication) { binary_operator '*' }
  rule(:division) { binary_operator '/' }
  rule(:assignment) { binary_operator '=' }

  # No statements! Only expressions.
  rule(:expression) do
    math = (multiplication | division | addition | subtraction)
    math.as(:math) | assignment.as(:assignment) | grouped(expression) | negation.as(:negation) | bit
  end

  root(:expression)
end