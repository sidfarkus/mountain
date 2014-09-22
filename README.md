mountain
===

A ruby-like language with experimental constraints. 

Grammar
---

mountain borrows much of its grammar from Ruby however the types and constraint syntax is a variant of Haskell/Idris.

    x = 5  # Implicit 'let' expression defining a bound variable
    let x : Int = 5 # Explicit 'let' expression
    let x : Int, y : String = 10, 'What?'
    
    # Maths follows standard rules, exponentiation is ^
    y = (x * 10 / 5) ^ 8
    
    # Floating point numbers use normal syntax and are always represented as 64-bit floats
    y = 10.0 / 2.0
    
    # Strings are restricted compared to Ruby, there are 3 ways to define a string:
    # - Single quoted strings are not escaped but are interpolated
    'this "is" a #{x} string'
    
    # - Double quoted strings are escaped and interpolated
    "another 'string' is #{x} here!"
    
    # - Triple quoted strings function as heredocs and preserve all whitespace past the indentation level of
    #   the triple quote
    y = """this
           is
           a
             triple
             quoted
                string!
        """
    
    # Comparisons are the standard fare however there is no === operator.  `If` expressions return the result.
    if x >= 5
      10
    else
      "whoa!"
    end
    
    # infix `if`
    "returned!" if 10 < 7
    

