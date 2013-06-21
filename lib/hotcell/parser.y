class Hotcell::Parser

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
  document: document document_unit { val[0].children.push(val[1]) }
          | document_unit { result = Joiner.build :JOINER, val[0] }
  document_unit: template | tag | block_tag | command_tag

  template: TEMPLATE { result = val[0] }
  tag: TOPEN TCLOSE { result = Tag.build :TAG, mode: TAG_MODES[val[0]] }
     | TOPEN sequence TCLOSE { result = Tag.build :TAG, *Array.wrap(val[1]).flatten, mode: TAG_MODES[val[0]] }

  command_body: COMMAND { result = Command.build val[0] }
              | COMMAND arguments { result = Command.build val[0], *val[1] }
  command: command_body
         | IDENTIFER ASSIGN command_body { result = Assigner.build val[0], val[2] }
  command_tag: TOPEN command TCLOSE {
                 command = val[1].is_a?(Command) ? val[1] : val[1].children[1]
                 command.validate!
                 result = Tag.build :TAG, val[1], mode: TAG_MODES[val[0]]
               }

  subcommand: SUBCOMMAND { result = { name: val[0] } }
            | SUBCOMMAND arguments { result = { name: val[0], args: Arrayer.build(:ARRAY, *val[1]) } }
  subcommand_tag: TOPEN subcommand TCLOSE { result = val[1] }

  block_body: BLOCK { result = Block.build val[0] }
            | BLOCK arguments { result = Block.build val[0], *val[1] }
  block_open: block_body
            | IDENTIFER ASSIGN block_body { result = Assigner.build val[0], val[2] }
  block_close: ENDBLOCK
             | END BLOCK
  block_open_tag: TOPEN block_open TCLOSE { result = Tag.build :TAG, val[1], mode: TAG_MODES[val[0]] }
  block_close_tag: TOPEN block_close TCLOSE
  block_subnodes: block_subnodes document_unit {
                    val[0][-1].is_a?(Joiner) ?
                      val[0][-1].children.push(val[1]) :
                      val[0].push(Joiner.build(:JOINER, val[1]))
                  }
                | block_subnodes subcommand_tag { val[0].push(val[1]) }
                | document_unit { result = [Joiner.build(:JOINER, val[0])] }
                | subcommand_tag { result = [val[0]] }
  block_tag: block_open_tag block_close_tag {
           block = val[0].children[0].is_a?(Block) ?
             val[0].children[0] : val[0].children[0].children[1]
           block.validate!
         }
       | block_open_tag block_subnodes block_close_tag
         {
           block = val[0].children[0].is_a?(Block) ?
             val[0].children[0] : val[0].children[0].children[1]
           block.options[:subnodes] = val[1]
           block.validate!
         }


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
      | IDENTIFER ASSIGN expr { result = Assigner.build val[0], val[2] }
      | expr PERIOD method { val[2].children[0] = val[0]; result = val[2] }
      | expr AOPEN arguments ACLOSE { result = Summoner.build 'manipulator_brackets', val[0], *val[2] }
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
  method: IDENTIFER { result = Summoner.build val[0] }
        | IDENTIFER POPEN PCLOSE { result = Summoner.build val[0] }
        | IDENTIFER POPEN arguments PCLOSE { result = Summoner.build val[0], nil, *val[2] }

---- header
  require 'hotcell/lexer'
---- inner
  NEWLINE_PRED = Set.new(Lexer::BOPEN.values + Lexer::OPERATIONS.values)
  NEWLINE_NEXT = Set.new(Lexer::BCLOSE.values + [:NEWLINE])

  TAG_MODES = { '{{' => :normal, '{{!' => :silence }

  def initialize string, options = {}
    @lexer = Lexer.new(string)
    @tokens = @lexer.tokens
    @position = -1

    @commands = Set.new(Array.wrap(options[:commands]).map(&:to_s))
    @blocks = Set.new(Array.wrap(options[:blocks]).map(&:to_s))
    @endblocks = Set.new(Array.wrap(options[:blocks]).map { |identifer| "end#{identifer}" })
    @subcommands = Set.new(Array.wrap(options[:subcommands]).map(&:to_s))
  end

  def parse
    if @tokens.size == 0
      Joiner.build :JOINER
    else
      do_parse
    end
  end

  def next_token
    @position = @position + 1

    tcurr = @tokens[@position]
    tnext = @tokens[@position.next]
    tpred = @tokens[@position.pred]

    if tcurr && (tcurr[0] == :COMMENT || tcurr[0] == :NEWLINE && (
      (tpred && NEWLINE_PRED.include?(tpred[0])) ||
      (tnext && NEWLINE_NEXT.include?(tnext[0]))
    ))
      next_token
    else
      if tcurr && tcurr[0] == :IDENTIFER
        if @commands.include?(tcurr[1])
          [:COMMAND, tcurr[1]]
        elsif @blocks.include?(tcurr[1])
          [:BLOCK, tcurr[1]]
        elsif @endblocks.include?(tcurr[1])
          [:ENDBLOCK, tcurr[1]]
        elsif @subcommands.include?(tcurr[1])
          [:SUBCOMMAND, tcurr[1]]
        elsif tcurr[1] == 'end'
          [:END, tcurr[1]]
        else
          tcurr
        end
      else
        tcurr || [false, false]
      end
    end
  end

  def on_error(token, value, vstack)
    raise Hotcell::UnexpectedLexem.new("#{token_to_str(token) || '?'} `#{value}`",
      *value.hotcell_position)
  end
