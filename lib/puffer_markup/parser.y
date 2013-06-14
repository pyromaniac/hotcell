class PufferMarkup::Parser

# Yes [ ] [ ]=  Element reference, element set
# Yes **  Exponentiation (raise to the power)
# Yes ! ~ + - Not, complement, unary plus and minus (method names for the last two are +@ and -@)
# Yes * / % Multiply, divide, and modulo
# Yes + - Addition and subtraction
# Yes <= < > >= Comparison operators
# Yes <=> == === != =~ !~ Equality and pattern match operators (!= and !~ may not be defined as methods)
# &&  Logical `AND'
# ||  Logical `AND'
# .. ...  Range (inclusive and exclusive)
# ? : Ternary if-then-else
# = %= { /= -= += |= &= >>= <<= *= &&= ||= **=  Assignment

# . :: [] (method) left to right
#  ! ~ + (unary)   right to left
# **   right to left
# - (unary)  right to left
# * / %  left to right
# + - (binary)   left to right
# &  left to right
# | ^  left to right
# > >= < <=  left to right
# <=> == === != =~ !~  not associative
# &&   left to right
# ||   left to right
# .. ...   not associative
#  ?:  right to left
# = **= *= <<= >>= &&= &= ||= |= += -= /= ^= %=  right to left
# , :   not associative
# not  right to left
# or and   left to right
#  ;   left to right

prechigh
  nonassoc NEGATIVE
  left PERIOD AOPEN
  right UPLUS NOT
  right POWER
  right UMINUS
  left MULTIPLY DIVIDE MODULO
  left PLUS MINUS
  left GT GTE LT LTE
  nonassoc EQUAL INEQUAL
  left AND
  left OR
  right TERNARY
  right ASSIGN
  nonassoc COMMA COLON
  left SEMICOLON NEWLINE
preclow
start document
rule
  document: document template { val[0].children.push(val[1]) }
          | document tag { val[0].children.push(val[1]) }
          | template { result = Document.build :DOCUMENT, val[0] }
          | tag { result = Document.build :DOCUMENT, val[0] }

  template: TEMPLATE { result = val[0] }
  tag: TOPEN TCLOSE { result = Tagger.build :TAG, mode: TAG_MODES[val[0]] }
     | TOPEN sequence TCLOSE { result = Tagger.build :TAG, *val[1].flatten, mode: TAG_MODES[val[0]] }

  sequence: sequence SEMICOLON sequence { result = val[0].push(val[2]) }
          | sequence SEMICOLON
          | SEMICOLON sequence { result = val[1] }
          | SEMICOLON { result = [] }
          | sequence NEWLINE sequence { result = val[0].push(val[2]) }
          | sequence NEWLINE
          | NEWLINE sequence { result = val[1] }
          | NEWLINE { result = [] }
          | expr { result = [val[0]] }

  expr: expr MULTIPLY expr { result = Calculator.build :MULTIPLY, val[0], val[2] }
      | expr POWER expr { result = Calculator.build :POWER, val[0], val[2] }
      | expr DIVIDE expr { result = Calculator.build :DIVIDE, val[0], val[2] }
      | expr PLUS expr { result = Calculator.build :PLUS, val[0], val[2] }
      | expr MINUS expr { result = Calculator.build :MINUS, val[0], val[2] }
      | expr MODULO expr { result = Calculator.build :MODULO, val[0], val[2] }
      | MINUS expr =UMINUS { result = Calculator.build :UMINUS, val[1] }
      | PLUS expr =UPLUS { result = Calculator.build :UPLUS, val[1] }
      | expr AND expr { result = Calculator.build :AND, val[0], val[2] }
      | expr OR expr { result = Calculator.build :OR, val[0], val[2] }
      | expr GT expr { result = Calculator.build :GT, val[0], val[2] }
      | expr GTE expr { result = Calculator.build :GTE, val[0], val[2] }
      | expr LT expr { result = Calculator.build :LT, val[0], val[2] }
      | expr LTE expr { result = Calculator.build :LTE, val[0], val[2] }
      | expr EQUAL expr { result = Calculator.build :EQUAL, val[0], val[2] }
      | expr INEQUAL expr { result = Calculator.build :INEQUAL, val[0], val[2] }
      | NOT expr { result = Calculator.build :NOT, val[1] }
      | IDENTIFER ASSIGN expr { result = Assigner.build :ASSIGN, val[0], val[2] }
      | expr PERIOD method { val[2].children[0] = val[0]; result = val[2] }
      | expr AOPEN arguments ACLOSE { result = Summoner.build :METHOD, val[0], '[]', *val[2] }
      | POPEN PCLOSE { result = nil }
      | POPEN sequence PCLOSE {
        result = case val[1].size
        when 0
          nil
        when 1
          val[1][0]
        else
          Sequencer.build :SEQUENCE, *val[1].flatten
        end
      }
      | value

  value: const | number | string | array | hash | method# | ternary

  const: NIL | TRUE | FALSE
  number: INTEGER | FLOAT
  string: STRING | REGEXP

  # ternary: expr QUESTION expr COLON expr =TERNARY { result = Node.build :TERNARY, val[0], val[2], val[4] }

  array: AOPEN ACLOSE { result = Arrayer.build :ARRAY }
       | AOPEN params ACLOSE { result = Arrayer.build :ARRAY, *val[1] }
  params: params COMMA expr { val[0].push(val[2]) }
        | expr { result = [val[0]] }

  hash: HOPEN HCLOSE { result = Hasher.build :HASH }
      | HOPEN pairs HCLOSE { result = Hasher.build :HASH, *val[1] }
  pairs: pairs COMMA pair { val[0].push(val[2]) }
       | pair { result = [val[0]] }
  pair: IDENTIFER COLON expr { result = Arrayer.build :PAIR, val[0], val[2] }

  arguments: params COMMA pairs { result = [*val[0], Hasher.build(:HASH, *val[2])] }
           | params
           | pairs { result = Hasher.build(:HASH, *val[0]) }
  method: IDENTIFER { result = Summoner.build :METHOD, nil, val[0] }
        | IDENTIFER POPEN PCLOSE { result = Summoner.build :METHOD, nil, val[0] }
        | IDENTIFER POPEN arguments PCLOSE { result = Summoner.build :METHOD, nil, val[0], *val[2] }

---- header
  require 'puffer_markup/lexer'
---- inner
  NEWLINE_PRED = Set.new(Lexer::BOPEN.values + Lexer::OPERATIONS.values)
  NEWLINE_NEXT = Set.new(Lexer::BCLOSE.values + [:NEWLINE])

  TAG_MODES = { '{{' => :normal, '{{!' => :silence, '{{/' => :block_close }

  def initialize string
    @lexer = Lexer.new(string)
    @tokens = @lexer.tokens
    @position = -1
  end

  def parse
    if @tokens.size == 0
      Document.build :DOCUMENT
    else
      do_parse
    end
  end

  def next_token
    @position = @position + 1
    if tcurr && (tcurr[0] == :COMMENT || tcurr[0] == :NEWLINE && (
      (tpred && NEWLINE_PRED.include?(tpred[0])) ||
      (tnext && NEWLINE_NEXT.include?(tnext[0]))
    ))
      next_token
    else
      tcurr || [false, false]
    end
  end

  def tcurr
    @tokens[@position]
  end

  def tnext
    @tokens[@position.next]
  end

  def tpred
    @tokens[@position.pred]
  end
