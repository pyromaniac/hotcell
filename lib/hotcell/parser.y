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
  nonassoc RANGE
  right TERNARY
  right ASSIGN
  nonassoc COMMA COLON
  left SEMICOLON NEWLINE
preclow
start document
rule
  document: document document_unit { pospoppush(2); val[0].push(val[1]) }
          | document_unit { result = [val[0]] }
  document_unit: template | tag | block_tag | command_tag

  template: TEMPLATE { result = val[0] }
  tag: TOPEN TCLOSE {
         result = build Tag, :TAG,
           mode: tag_modes(val[0], @escape_tags ? :escape : :normal),
           position: pospoppush(2)
       }
     | TOPEN sequence TCLOSE {
         result = build Tag, :TAG,
           *Array.wrap(val[1]).flatten,
           mode: tag_modes(val[0], @escape_tags ? :escape : :normal),
           position: pospoppush(3)
       }

  command_body: COMMAND { result = build @commands[val[0]] || Command, val[0], position: pospoppush(1) }
              | COMMAND arguments {
                  result = build @commands[val[0]] || Command, val[0], *val[1], position: pospoppush(2)
                }
  command: command_body
         | IDENTIFER ASSIGN command_body {
             result = build Assigner, val[0], val[2], position: pospoppush(3)
           }
  command_tag: TOPEN command TCLOSE {
                 command = val[1].is_a?(Command) ? val[1] : val[1].children[0]
                 command.validate!
                 result = build Tag, :TAG, val[1], mode: tag_modes(val[0]), position: pospoppush(3)
               }

  subcommand: SUBCOMMAND { result = build @substack.last[val[0]], val[0], position: pospoppush(1) }
            | SUBCOMMAND arguments {
                result = build @substack.last[val[0]], val[0], *val[1], position: pospoppush(2)
              }
  subcommand_tag: TOPEN subcommand TCLOSE { pospoppush(3); result = val[1] }

  block_body: BLOCK { result = build @blocks[val[0]] || Block, val[0], position: pospoppush(1) }
            | BLOCK arguments {
                result = build @blocks[val[0]] || Block, val[0], *val[1], position: pospoppush(2)
              }
  block_open: block_body
            | IDENTIFER ASSIGN block_body {
                result = build Assigner, val[0], val[2], position: pospoppush(3)
              }
  block_close: ENDBLOCK
             | END BLOCK { pospoppush(2) }
             | END
  block_open_tag: TOPEN block_open TCLOSE {
                    result = build Tag, :TAG, val[1], mode: tag_modes(val[0]), position: pospoppush(3)
                  }
  block_close_tag: TOPEN block_close TCLOSE { pospoppush(3) }
  block_subnodes: block_subnodes document_unit {
                    pospoppush(2)
                    val[0][-1].is_a?(Joiner) ?
                      val[0][-1].children.push(val[1]) :
                      val[0].push(build(Joiner, :JOINER, val[1]))
                  }
                | block_subnodes subcommand_tag { pospoppush(2); val[0].push(val[1]) }
                | document_unit { result = [build(Joiner, :JOINER, val[0], position: pospoppush(1))] }
                | subcommand_tag { result = [val[0]] }
  block_tag: block_open_tag block_close_tag {
               pospoppush(2)
               block = val[0].children[0].is_a?(Block) ?
                 val[0].children[0] : val[0].children[0].children[0]
               block.validate!
             }
           | block_open_tag block_subnodes block_close_tag {
               pospoppush(3)
               block = val[0].children[0].is_a?(Block) ?
                 val[0].children[0] : val[0].children[0].children[0]
               block.options[:subnodes] = val[1]
               block.validate!
             }

  sequence: sequence SEMICOLON sequence { pospoppush(2); result = val[0].push(val[2]) }
          | sequence SEMICOLON { pospoppush(2) }
          | SEMICOLON sequence { pospoppush(2, 1); result = val[1] }
          | SEMICOLON { result = [] }
          | sequence NEWLINE sequence { pospoppush(2); result = val[0].push(val[2]) }
          | sequence NEWLINE { pospoppush(2) }
          | NEWLINE sequence { pospoppush(2, 1); result = val[1] }
          | NEWLINE { result = [] }
          | expr { result = [val[0]] }

  expr: expr MULTIPLY expr { result = build Expression, :MULTIPLY, val[0], val[2], position: pospoppush(3) }
      | expr POWER expr { result = build Expression, :POWER, val[0], val[2], position: pospoppush(3) }
      | expr DIVIDE expr { result = build Expression, :DIVIDE, val[0], val[2], position: pospoppush(3) }
      | expr PLUS expr { result = build Expression, :PLUS, val[0], val[2], position: pospoppush(3) }
      | expr MINUS expr { result = build Expression, :MINUS, val[0], val[2], position: pospoppush(3) }
      | expr MODULO expr { result = build Expression, :MODULO, val[0], val[2], position: pospoppush(3) }
      | MINUS expr =UMINUS { result = build Expression, :UMINUS, val[1], position: pospoppush(2) }
      | PLUS expr =UPLUS { result = build Expression, :UPLUS, val[1], position: pospoppush(2) }
      | expr AND expr { result = build Expression, :AND, val[0], val[2], position: pospoppush(3) }
      | expr OR expr { result = build Expression, :OR, val[0], val[2], position: pospoppush(3) }
      | expr GT expr { result = build Expression, :GT, val[0], val[2], position: pospoppush(3) }
      | expr GTE expr { result = build Expression, :GTE, val[0], val[2], position: pospoppush(3) }
      | expr LT expr { result = build Expression, :LT, val[0], val[2], position: pospoppush(3) }
      | expr LTE expr { result = build Expression, :LTE, val[0], val[2], position: pospoppush(3) }
      | expr EQUAL expr { result = build Expression, :EQUAL, val[0], val[2], position: pospoppush(3) }
      | expr INEQUAL expr { result = build Expression, :INEQUAL, val[0], val[2], position: pospoppush(3) }
      | NOT expr { result = build Expression, :NOT, val[1], position: pospoppush(2) }
      | IDENTIFER ASSIGN expr { result = build Assigner, val[0], val[2], position: pospoppush(3) }
      | expr PERIOD method { pospoppush(3); val[2].children[0] = val[0]; result = val[2] }
      | expr AOPEN arguments ACLOSE {
          result = build Summoner, '[]', val[0], *val[2], position: pospoppush(4)
        }
      | POPEN PCLOSE { pospoppush(2); result = nil }
      | POPEN sequence PCLOSE {
          result = case val[1].size
          when 1
            val[1][0]
          else
            build Sequencer, :SEQUENCE, *val[1].flatten, position: pospoppush(3)
          end
        }
      | value

  value: const | number | string | dstring | regexp | range | array | hash | method

  const: NIL | TRUE | FALSE
  number: INTEGER | FLOAT
  string: STRING
  regexp: REGEXP

  dstring: DOPEN dstring_content DCLOSE { result = build Expression, :DSTRING, *val[1], position: pospoppush(3) }
         | DOPEN DCLOSE { pospoppush(2); result = '' }
  dstring_content: STRING { result = [val[0]] }
                 | dstring_interpolation { result = [val[0]] }
                 | dstring_content STRING { pospoppush(2); val[0].push(val[1]); result = val[0] }
                 | dstring_content dstring_interpolation { pospoppush(2); val[0].push(val[1]); result = val[0] }
  dstring_interpolation: IOPEN sequence ICLOSE {
                           result = case val[1].size
                           when 1
                             val[1][0]
                           else
                             build Sequencer, :SEQUENCE, *val[1].flatten, position: pospoppush(3)
                           end
                         }
                       | IOPEN ICLOSE { pospoppush(2); result = nil }

  range: expr RANGE expr {
           result = build Expression, val[1] == '..' ? :RANGE : :ERANGE,
             val[0], val[2], position: pospoppush(3)
         }

  array: AOPEN ACLOSE { result = build Arrayer, :ARRAY, position: pospoppush(2) }
       | AOPEN params ACLOSE { result = build Arrayer, :ARRAY, *val[1], position: pospoppush(3) }
  params: params COMMA expr { pospoppush(3); val[0].push(val[2]) }
        | expr { result = [val[0]] }

  hash: HOPEN HCLOSE { result = build Hasher, :HASH, position: pospoppush(2) }
      | HOPEN pairs HCLOSE { result = build Hasher, :HASH, *val[1], position: pospoppush(3) }
  pairs: pairs COMMA pair { pospoppush(3); val[0].push(val[2]) }
       | pair { result = [val[0]] }
  pair: IDENTIFER COLON expr { result = build Arrayer, :PAIR, val[0], val[2], position: pospoppush(3) }

  arguments: params COMMA pairs { result = [*val[0], build(Hasher, :HASH, *val[2], position: pospoppush(3))] }
           | params
           | pairs { result = build Hasher, :HASH, *val[0], position: pospoppush(1) }
  method: IDENTIFER { result = build Summoner, val[0], position: pospoppush(1) }
        | IDENTIFER POPEN PCLOSE { result = build Summoner, val[0], position: pospoppush(3) }
        | IDENTIFER POPEN arguments PCLOSE {
            result = build Summoner, val[0], nil, *val[2], position: pospoppush(4)
          }

---- inner
  OPERATIONS = {
    '+' => :PLUS, '-' => :MINUS, '*' => :MULTIPLY, '**' => :POWER, '/' => :DIVIDE, '%' => :MODULO,

    '&&' => :AND, '||' => :OR, '!' => :NOT, '==' => :EQUAL, '!=' => :INEQUAL,
    '>' => :GT, '>=' => :GTE, '<' => :LT, '<=' => :LTE,

    '=' => :ASSIGN, ',' => :COMMA, '.' => :PERIOD, ':' => :COLON, '?' => :QUESTION,
    ';' => :SEMICOLON
  }

  BOPEN = { '[' => :AOPEN, '{' => :HOPEN, '(' => :POPEN }
  BCLOSE = { ']' => :ACLOSE, '}' => :HCLOSE, ')' => :PCLOSE }

  NEWLINE_PRED = Set.new(BOPEN.values + OPERATIONS.values)
  NEWLINE_NEXT = Set.new(BCLOSE.values + [:NEWLINE])

  TAG_MODES = {
    '!' => :silence, '^' => :escape, 'e' => :escape,
    '~' => :normal, 'r' => :normal
  }

  def initialize source, options = {}
    @source = Source.wrap(source)
    @lexer = Lexer.new(source)
    @tokens = @lexer.tokens
    @position = -1

    @commands = options[:commands] || {}
    @blocks = options[:blocks] || {}
    @endblocks = Set.new(@blocks.keys.map { |identifer| "end#{identifer}" })
    @escape_tags = !!options[:escape_tags]

    @substack = []
    @posstack = []
  end

  def build klass, *args
    options = args.extract_options!
    options[:source] = @source
    klass.build *args.push(options)
  end

  def pospoppush pop, push = 0
    # because fuck the brains, that's why!
    last = @posstack.pop
    reduced = @posstack.push(@posstack.pop(pop)[push])[-1]
    @posstack.push last
    reduced
  end

  def tag_modes tag, default = :normal
    mode = tag.gsub(/^{{/, '').first
    TAG_MODES[mode] || default
  end

  def parse
    children = @tokens.size.zero? ? [] : do_parse
    build Joiner, :JOINER, *children, position: 0
  end

  def next_token
    @position = @position + 1
    tcurr = @tokens[@position]

    if tcurr && (tcurr[0] == :COMMENT || tcurr[0] == :NEWLINE && (
      ((tpred = @tokens[@position.pred]) && NEWLINE_PRED.include?(tpred[0])) ||
      ((tnext = @tokens[@position.next]) && NEWLINE_NEXT.include?(tnext[0]))
    ))
      next_token
    else
      if tcurr
        @posstack << tcurr[1][1]
        tcurr = [tcurr[0], tcurr[1][0]]
      end

      if tcurr && tcurr[0] == :IDENTIFER
        if @commands.key?(tcurr[1])
          [:COMMAND, tcurr[1]]
        elsif @blocks.key?(tcurr[1])
          @substack.push(@blocks[tcurr[1]].subcommands)
          [:BLOCK, tcurr[1]]
        elsif @substack.last && @substack.last.key?(tcurr[1])
          [:SUBCOMMAND, tcurr[1]]
        elsif @endblocks.include?(tcurr[1])
          @substack.pop
          [:ENDBLOCK, tcurr[1]]
        elsif tcurr[1] == 'end'
          @substack.pop
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
      *@source.info(@posstack.last).values_at(:line, :column))
  end
