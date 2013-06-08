class PufferMarkup::Parser
prechigh
  nonassoc COMMAND
  nonassoc UMINUS UPLUS NOT
  left MULTIPLY DIVIDE
  left PLUS MINUS
  right ASSIGN
preclow
start tag
rule
  tag: TOPEN TCLOSE { result = Node.build :TAG }
     | TOPEN statement TCLOSE { result = Node.build :TAG, val[1] }

  statement: command =COMMAND
           | expr

  expr: expr MULTIPLY expr { result = Node.build :MULTIPLY, val[0], val[2] }
      | expr DIVIDE expr { result = Node.build :DIVIDE, val[0], val[2] }
      | expr PLUS expr { result = Node.build :PLUS, val[0], val[2] }
      | expr MINUS expr { result = Node.build :MINUS, val[0], val[2] }
      | MINUS expr =UMINUS { result = Node.build :UMINUS, val[1] }
      | PLUS expr =UPLUS { result = Node.build :UPLUS, val[1] }
      | BOPEN expr BCLOSE { result = val[1] }
      | value

  const: NIL | TRUE | FALSE
  number: INTEGER | FLOAT
  string: STRING | REGEXP
  identifer: IDENTIFER { result = Node.build :IDENTIFER, val[0] }

  array: AOPEN ACLOSE { result = Node.build :ARRAY }
       | AOPEN params ACLOSE { result = Node.build :ARRAY, val[1] }
  params: params COMMA expr { val[0].children.push(val[2]); result = val[0]  }
        | expr { result = Node.build :PARAMS, val[0]  }

  hash: HOPEN HCLOSE { result = Node.build :HASH }
      | HOPEN pairs HCLOSE { result = Node.build :HASH, val[1] }
  pairs: pairs COMMA pair { val[0].children.push(val[2]); result = val[0] }
       | pair { result = Node.build :PAIRS, val[0] }
  pair: identifer COLON expr { result = Node.build :PAIR, val[0], val[2] }

  value: const | number | string | array | hash | identifer | function

  arguments: params { result = Node.build :ARGUMENTS, val[0] }
           | pairs { result = Node.build :ARGUMENTS, val[0] }
           | params COMMA pairs { result = Node.build :ARGUMENTS, val[0], val[2] }
  function: identifer BOPEN arguments BCLOSE { result = Node.build :FUNCTION, val[0], val[2] }

  command: identifer arguments { result = Node.build :FUNCTION, val[0], val[1] }

---- header
  require 'puffer_markup/lexer'
---- inner
  def initialize string
    @lexer = Lexer.new(string)
    @tokens = @lexer.tokens
    @position = -1
  end

  def parse
    do_parse
  end

  def next_token
    @position = @position + 1
    @tokens[@position] || [false, false]
  end