
# line 1 "lib/hotcell/lexer.rl"

# line 97 "lib/hotcell/lexer.rl"

#%

module Hotcell
  class Lexer
    OPERATIONS = {
      '+' => :PLUS, '-' => :MINUS, '*' => :MULTIPLY, '**' => :POWER, '/' => :DIVIDE, '%' => :MODULO,

      '&&' => :AND, '||' => :OR, '!' => :NOT, '==' => :EQUAL, '!=' => :INEQUAL,
      '>' => :GT, '>=' => :GTE, '<' => :LT, '<=' => :LTE,

      '=' => :ASSIGN, ',' => :COMMA, '.' => :PERIOD, ':' => :COLON, '?' => :QUESTION,
      ';' => :SEMICOLON
    }

    BOPEN = { '[' => :AOPEN, '{' => :HOPEN, '(' => :POPEN }
    BCLOSE = { ']' => :ACLOSE, '}' => :HCLOSE, ')' => :PCLOSE }
    BRACKETS = BOPEN.merge(BCLOSE)

    OPERATORS = OPERATIONS.merge(BRACKETS).merge("\n" => :NEWLINE)

    CONSTANTS = {
      'nil' => [:NIL, nil], 'null' => [:NIL, nil],
      'false' => [:FALSE, false], 'true' => [:TRUE, true]
    }

    SSTRING_ESCAPE_REGEXP = /\\\'|\\\\/
    SSTRING_ESCAPE_MAP = { "\\'" => "'", "\\\\" => "\\" }

    DSTRING_ESCAPE_REGEXP = /\\./
    DSTRING_ESCAPE_MAP = {
      '\\"' => '"', "\\\\" => "\\", '\n' => "\n",
      '\s' => "\s", '\r' => "\r", '\t' => "\t"
    }

    TAGS = {
      '{{' => :TOPEN, '{{!' => :TOPEN,
      '}}' => :TCLOSE
    }

    PREREGEXP = Set.new [
      :TOPEN, :NEWLINE, :SEMICOLON,
      :COLON, :COMMA, :PERIOD,
      :POPEN, :AOPEN, :HOPEN
    ]

    def initialize source
      @source = source
      @data = @source.unpack 'c*'

      
# line 57 "lib/hotcell/lexer.rb"
class << self
	attr_accessor :_puffer_lexer_actions
	private :_puffer_lexer_actions, :_puffer_lexer_actions=
end
self._puffer_lexer_actions = [
	0, 1, 0, 1, 1, 1, 3, 1, 
	4, 1, 5, 1, 8, 1, 9, 1, 
	10, 1, 11, 1, 12, 1, 13, 1, 
	14, 1, 15, 1, 16, 1, 17, 1, 
	18, 1, 19, 1, 20, 1, 21, 1, 
	22, 1, 23, 1, 24, 1, 25, 1, 
	26, 1, 27, 1, 28, 2, 5, 2, 
	2, 5, 6, 2, 5, 7
]

class << self
	attr_accessor :_puffer_lexer_key_offsets
	private :_puffer_lexer_key_offsets, :_puffer_lexer_key_offsets=
end
self._puffer_lexer_key_offsets = [
	0, 0, 2, 2, 3, 4, 6, 6, 
	8, 8, 10, 11, 12, 13, 14, 15, 
	17, 48, 49, 51, 52, 54, 56, 60, 
	63, 72, 73, 74, 75
]

class << self
	attr_accessor :_puffer_lexer_trans_keys
	private :_puffer_lexer_trans_keys, :_puffer_lexer_trans_keys=
end
self._puffer_lexer_trans_keys = [
	34, 92, 125, 38, 39, 92, 47, 92, 
	48, 57, 124, 125, 123, 123, 123, 33, 
	35, 10, 32, 33, 34, 35, 38, 39, 
	42, 46, 47, 63, 91, 93, 95, 123, 
	124, 125, 9, 13, 37, 45, 48, 57, 
	58, 59, 60, 62, 65, 90, 97, 122, 
	61, 10, 125, 42, 48, 57, 47, 92, 
	65, 90, 97, 122, 46, 48, 57, 33, 
	63, 95, 48, 57, 65, 90, 97, 122, 
	125, 35, 35, 125, 0
]

class << self
	attr_accessor :_puffer_lexer_single_lengths
	private :_puffer_lexer_single_lengths, :_puffer_lexer_single_lengths=
end
self._puffer_lexer_single_lengths = [
	0, 2, 0, 1, 1, 2, 0, 2, 
	0, 0, 1, 1, 1, 1, 1, 2, 
	17, 1, 2, 1, 0, 2, 0, 1, 
	3, 1, 1, 1, 1
]

class << self
	attr_accessor :_puffer_lexer_range_lengths
	private :_puffer_lexer_range_lengths, :_puffer_lexer_range_lengths=
end
self._puffer_lexer_range_lengths = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 1, 0, 0, 0, 0, 0, 0, 
	7, 0, 0, 0, 1, 0, 2, 1, 
	3, 0, 0, 0, 0
]

class << self
	attr_accessor :_puffer_lexer_index_offsets
	private :_puffer_lexer_index_offsets, :_puffer_lexer_index_offsets=
end
self._puffer_lexer_index_offsets = [
	0, 0, 3, 4, 6, 8, 11, 12, 
	15, 16, 18, 20, 22, 24, 26, 28, 
	31, 56, 58, 61, 63, 65, 68, 71, 
	74, 81, 83, 85, 87
]

class << self
	attr_accessor :_puffer_lexer_trans_targs
	private :_puffer_lexer_trans_targs, :_puffer_lexer_trans_targs=
end
self._puffer_lexer_trans_targs = [
	16, 2, 1, 1, 16, 18, 16, 0, 
	16, 6, 5, 5, 22, 8, 7, 7, 
	20, 16, 16, 0, 26, 26, 14, 13, 
	12, 13, 15, 12, 12, 12, 12, 16, 
	16, 17, 1, 18, 4, 5, 19, 20, 
	21, 16, 16, 16, 24, 16, 10, 25, 
	16, 16, 23, 16, 17, 24, 24, 0, 
	16, 16, 16, 3, 18, 16, 16, 20, 
	16, 22, 8, 7, 22, 22, 16, 9, 
	23, 16, 16, 16, 24, 24, 24, 24, 
	16, 16, 16, 28, 27, 26, 27, 11, 
	26, 16, 16, 16, 16, 26, 12, 12, 
	12, 16, 16, 16, 16, 16, 16, 16, 
	16, 16, 26, 26, 0
]

class << self
	attr_accessor :_puffer_lexer_trans_actions
	private :_puffer_lexer_trans_actions, :_puffer_lexer_trans_actions=
end
self._puffer_lexer_trans_actions = [
	19, 0, 0, 0, 37, 9, 13, 0, 
	17, 0, 0, 0, 0, 0, 0, 0, 
	59, 35, 13, 0, 41, 45, 0, 0, 
	51, 0, 0, 51, 47, 47, 49, 13, 
	21, 0, 0, 9, 0, 0, 0, 56, 
	53, 13, 13, 13, 0, 13, 0, 0, 
	21, 13, 9, 13, 0, 0, 0, 0, 
	13, 23, 31, 0, 9, 13, 23, 59, 
	39, 0, 0, 0, 0, 0, 29, 0, 
	9, 25, 15, 15, 0, 0, 0, 0, 
	27, 11, 23, 9, 0, 43, 0, 0, 
	43, 37, 33, 33, 35, 45, 51, 51, 
	49, 23, 31, 23, 39, 23, 29, 25, 
	27, 23, 43, 43, 0
]

class << self
	attr_accessor :_puffer_lexer_to_state_actions
	private :_puffer_lexer_to_state_actions, :_puffer_lexer_to_state_actions=
end
self._puffer_lexer_to_state_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 5, 0, 0, 0, 
	5, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 5, 0, 0
]

class << self
	attr_accessor :_puffer_lexer_from_state_actions
	private :_puffer_lexer_from_state_actions, :_puffer_lexer_from_state_actions=
end
self._puffer_lexer_from_state_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 7, 0, 0, 0, 
	7, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 7, 0, 0
]

class << self
	attr_accessor :_puffer_lexer_eof_actions
	private :_puffer_lexer_eof_actions, :_puffer_lexer_eof_actions=
end
self._puffer_lexer_eof_actions = [
	0, 3, 0, 0, 0, 1, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0
]

class << self
	attr_accessor :_puffer_lexer_eof_trans
	private :_puffer_lexer_eof_trans, :_puffer_lexer_eof_trans=
end
self._puffer_lexer_eof_trans = [
	0, 0, 0, 90, 0, 0, 0, 92, 
	92, 93, 0, 94, 0, 96, 96, 97, 
	0, 106, 99, 106, 101, 106, 103, 104, 
	105, 106, 0, 108, 108
]

class << self
	attr_accessor :puffer_lexer_start
end
self.puffer_lexer_start = 12;
class << self
	attr_accessor :puffer_lexer_first_final
end
self.puffer_lexer_first_final = 12;
class << self
	attr_accessor :puffer_lexer_error
end
self.puffer_lexer_error = 0;

class << self
	attr_accessor :puffer_lexer_en_expression
end
self.puffer_lexer_en_expression = 16;
class << self
	attr_accessor :puffer_lexer_en_template_comment
end
self.puffer_lexer_en_template_comment = 26;
class << self
	attr_accessor :puffer_lexer_en_main
end
self.puffer_lexer_en_main = 12;


# line 148 "lib/hotcell/lexer.rl"
      #%
    end

    def emit symbol, value
      @token_array << [symbol, value]
    end

    def current_value
      @data[@ts...@te].pack('c*').force_encoding('UTF-8')
    end

    def emit_operator
      value = current_value
      emit OPERATORS[value], value
    end

    def emit_numeric
      # last = @token_array[-1]
      # pre_last = @token_array[-2]
      # # This need to give unary minus with numeric higher precedence then unari minus with
      # last[0] = :NEGATIVE if last && last[0] == :MINUS &&
      #   (!pre_last || pre_last[0].in?())

      value = current_value
      if value =~ /\./
        emit :FLOAT, Float(value)
      else
        emit :INTEGER, Integer(value)
      end
    end

    def emit_identifer
      value = current_value
      if args = CONSTANTS[value]
        emit *args
      else
        emit :IDENTIFER, value
      end
    end

    def emit_sstring
      emit :STRING, current_value[1..-2].gsub(SSTRING_ESCAPE_REGEXP) { |match|
        SSTRING_ESCAPE_MAP[match] }.force_encoding('UTF-8')
    end

    def emit_dstring
      emit :STRING, current_value[1..-2].gsub(DSTRING_ESCAPE_REGEXP) { |match|
        DSTRING_ESCAPE_MAP[match] || match[1] }
    end

    def regexp_ambiguity
      unless regexp_possible?
        emit_operator
        yield
      end
    end

    def regexp_possible?
      last = @token_array[-1]
      # Need more rules!
      !last || PREREGEXP.include?(last[0])
    end

    def emit_regexp
      value = current_value
      finish = value.rindex('/')

      options_string = value[finish+1..-1]
      options = 0
      options |= Regexp::EXTENDED if options_string.include?('x')
      options |= Regexp::IGNORECASE if options_string.include?('i')
      options |= Regexp::MULTILINE if options_string.include?('m')

      emit :REGEXP, Regexp.new(value[1..finish-1], options)
    end

    def emit_template
      # Hack this to glue templates going straight
      last = @token_array[-1]
      if last && last[0] == :TEMPLATE
        last[1] += current_value
      else
        emit :TEMPLATE, current_value
      end
    end

    def emit_tag_or_comment if_tag, if_comment
      value = current_value
      if value == '{{#'
        emit_comment
        if_comment.call
      else
        emit_tag
        if_tag.call
      end
    end

    def emit_tag
      value = current_value
      emit TAGS[value], value
    end

    def emit_comment
      last = @token_array[-1]
      if last && last[0] == :COMMENT
        last[1] += current_value
      else
        emit :COMMENT, current_value
      end
    end

    def current_position
      parsed = @data[0..@ts].pack('c*').force_encoding('UTF-8')
      line = parsed.count("\n") + 1
      column = parsed.size  - 1 - (parsed.rindex("\n") || -1)
      [line, column]
    end

    def raise_unexpected_symbol
      raise Hotcell::Errors::UnexpectedSymbol.new *current_position
    end

    def raise_unterminated_string
      raise Hotcell::Errors::UnterminatedString.new *current_position
    end

    def raise_unterminated_regexp
      raise Hotcell::Errors::UnterminatedRegexp.new *current_position
    end

    def tokens
      @tokens ||= tokenize
    end

    def tokenize
      @token_array = []

      
# line 386 "lib/hotcell/lexer.rb"
begin
	p ||= 0
	pe ||=  @data.length
	cs = puffer_lexer_start
	top = 0
	 @ts = nil
	 @te = nil
	act = 0
end

# line 286 "lib/hotcell/lexer.rl"
      #%

      eof = pe
      stack = []

      
# line 404 "lib/hotcell/lexer.rb"
begin
	_klen, _trans, _keys, _acts, _nacts = nil
	_goto_level = 0
	_resume = 10
	_eof_trans = 15
	_again = 20
	_test_eof = 30
	_out = 40
	while true
	_trigger_goto = false
	if _goto_level <= 0
	if p == pe
		_goto_level = _test_eof
		next
	end
	if cs == 0
		_goto_level = _out
		next
	end
	end
	if _goto_level <= _resume
	_acts = _puffer_lexer_from_state_actions[cs]
	_nacts = _puffer_lexer_actions[_acts]
	_acts += 1
	while _nacts > 0
		_nacts -= 1
		_acts += 1
		case _puffer_lexer_actions[_acts - 1]
			when 4 then
# line 1 "NONE"
		begin
 @ts = p
		end
# line 438 "lib/hotcell/lexer.rb"
		end # from state action switch
	end
	if _trigger_goto
		next
	end
	_keys = _puffer_lexer_key_offsets[cs]
	_trans = _puffer_lexer_index_offsets[cs]
	_klen = _puffer_lexer_single_lengths[cs]
	_break_match = false
	
	begin
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + _klen - 1

	     loop do
	        break if _upper < _lower
	        _mid = _lower + ( (_upper - _lower) >> 1 )

	        if  @data[p].ord < _puffer_lexer_trans_keys[_mid]
	           _upper = _mid - 1
	        elsif  @data[p].ord > _puffer_lexer_trans_keys[_mid]
	           _lower = _mid + 1
	        else
	           _trans += (_mid - _keys)
	           _break_match = true
	           break
	        end
	     end # loop
	     break if _break_match
	     _keys += _klen
	     _trans += _klen
	  end
	  _klen = _puffer_lexer_range_lengths[cs]
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + (_klen << 1) - 2
	     loop do
	        break if _upper < _lower
	        _mid = _lower + (((_upper-_lower) >> 1) & ~1)
	        if  @data[p].ord < _puffer_lexer_trans_keys[_mid]
	          _upper = _mid - 2
	        elsif  @data[p].ord > _puffer_lexer_trans_keys[_mid+1]
	          _lower = _mid + 2
	        else
	          _trans += ((_mid - _keys) >> 1)
	          _break_match = true
	          break
	        end
	     end # loop
	     break if _break_match
	     _trans += _klen
	  end
	end while false
	end
	if _goto_level <= _eof_trans
	cs = _puffer_lexer_trans_targs[_trans]
	if _puffer_lexer_trans_actions[_trans] != 0
		_acts = _puffer_lexer_trans_actions[_trans]
		_nacts = _puffer_lexer_actions[_acts]
		_acts += 1
		while _nacts > 0
			_nacts -= 1
			_acts += 1
			case _puffer_lexer_actions[_acts - 1]
when 2 then
# line 58 "lib/hotcell/lexer.rl"
		begin
 regexp_ambiguity { 	begin
		cs = 16
		_trigger_goto = true
		_goto_level = _again
		break
	end
 } 		end
when 5 then
# line 1 "NONE"
		begin
 @te = p+1
		end
when 6 then
# line 78 "lib/hotcell/lexer.rl"
		begin
act = 2;		end
when 7 then
# line 79 "lib/hotcell/lexer.rl"
		begin
act = 3;		end
when 8 then
# line 77 "lib/hotcell/lexer.rl"
		begin
 @te = p+1
 begin  emit_tag; 	begin
		top -= 1
		cs = stack[top]
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 9 then
# line 78 "lib/hotcell/lexer.rl"
		begin
 @te = p+1
 begin  emit_operator  end
		end
when 10 then
# line 80 "lib/hotcell/lexer.rl"
		begin
 @te = p+1
 begin  emit_identifer  end
		end
when 11 then
# line 81 "lib/hotcell/lexer.rl"
		begin
 @te = p+1
 begin  emit_sstring  end
		end
when 12 then
# line 82 "lib/hotcell/lexer.rl"
		begin
 @te = p+1
 begin  emit_dstring  end
		end
when 13 then
# line 85 "lib/hotcell/lexer.rl"
		begin
 @te = p+1
		end
when 14 then
# line 78 "lib/hotcell/lexer.rl"
		begin
 @te = p
p = p - 1; begin  emit_operator  end
		end
when 15 then
# line 79 "lib/hotcell/lexer.rl"
		begin
 @te = p
p = p - 1; begin  emit_numeric  end
		end
when 16 then
# line 80 "lib/hotcell/lexer.rl"
		begin
 @te = p
p = p - 1; begin  emit_identifer  end
		end
when 17 then
# line 83 "lib/hotcell/lexer.rl"
		begin
 @te = p
p = p - 1; begin  emit_regexp  end
		end
when 18 then
# line 84 "lib/hotcell/lexer.rl"
		begin
 @te = p
p = p - 1; begin  emit_comment  end
		end
when 19 then
# line 78 "lib/hotcell/lexer.rl"
		begin
 begin p = (( @te))-1; end
 begin  emit_operator  end
		end
when 20 then
# line 79 "lib/hotcell/lexer.rl"
		begin
 begin p = (( @te))-1; end
 begin  emit_numeric  end
		end
when 21 then
# line 84 "lib/hotcell/lexer.rl"
		begin
 begin p = (( @te))-1; end
 begin  emit_comment  end
		end
when 22 then
# line 1 "NONE"
		begin
	case act
	when 2 then
	begin begin p = (( @te))-1; end
 emit_operator end
	when 3 then
	begin begin p = (( @te))-1; end
 emit_numeric end
end 
			end
when 23 then
# line 89 "lib/hotcell/lexer.rl"
		begin
 @te = p+1
 begin  emit_comment; 	begin
		top -= 1
		cs = stack[top]
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 24 then
# line 90 "lib/hotcell/lexer.rl"
		begin
 @te = p
p = p - 1; begin  emit_comment  end
		end
when 25 then
# line 90 "lib/hotcell/lexer.rl"
		begin
 begin p = (( @te))-1; end
 begin  emit_comment  end
		end
when 26 then
# line 94 "lib/hotcell/lexer.rl"
		begin
 @te = p+1
 begin  emit_tag_or_comment ->{ 	begin
		stack[top] = cs
		top+= 1
		cs = 16
		_trigger_goto = true
		_goto_level = _again
		break
	end
 }, ->{ 	begin
		stack[top] = cs
		top+= 1
		cs = 26
		_trigger_goto = true
		_goto_level = _again
		break
	end
 }  end
		end
when 27 then
# line 94 "lib/hotcell/lexer.rl"
		begin
 @te = p
p = p - 1; begin  emit_tag_or_comment ->{ 	begin
		stack[top] = cs
		top+= 1
		cs = 16
		_trigger_goto = true
		_goto_level = _again
		break
	end
 }, ->{ 	begin
		stack[top] = cs
		top+= 1
		cs = 26
		_trigger_goto = true
		_goto_level = _again
		break
	end
 }  end
		end
when 28 then
# line 95 "lib/hotcell/lexer.rl"
		begin
 @te = p
p = p - 1; begin  emit_template  end
		end
# line 704 "lib/hotcell/lexer.rb"
			end # action switch
		end
	end
	if _trigger_goto
		next
	end
	end
	if _goto_level <= _again
	_acts = _puffer_lexer_to_state_actions[cs]
	_nacts = _puffer_lexer_actions[_acts]
	_acts += 1
	while _nacts > 0
		_nacts -= 1
		_acts += 1
		case _puffer_lexer_actions[_acts - 1]
when 3 then
# line 1 "NONE"
		begin
 @ts = nil;		end
# line 724 "lib/hotcell/lexer.rb"
		end # to state action switch
	end
	if _trigger_goto
		next
	end
	if cs == 0
		_goto_level = _out
		next
	end
	p += 1
	if p != pe
		_goto_level = _resume
		next
	end
	end
	if _goto_level <= _test_eof
	if p == eof
	if _puffer_lexer_eof_trans[cs] > 0
		_trans = _puffer_lexer_eof_trans[cs] - 1;
		_goto_level = _eof_trans
		next;
	end
	__acts = _puffer_lexer_eof_actions[cs]
	__nacts =  _puffer_lexer_actions[__acts]
	__acts += 1
	while __nacts > 0
		__nacts -= 1
		__acts += 1
		case _puffer_lexer_actions[__acts - 1]
when 0 then
# line 50 "lib/hotcell/lexer.rl"
		begin
 raise_unterminated_string 		end
when 1 then
# line 54 "lib/hotcell/lexer.rl"
		begin
 raise_unterminated_string 		end
# line 762 "lib/hotcell/lexer.rb"
		end # eof action switch
	end
	if _trigger_goto
		next
	end
end
	end
	if _goto_level <= _out
		break
	end
	end
	end

# line 292 "lib/hotcell/lexer.rl"
      #%

      raise_unexpected_symbol unless @ts.nil?

      @token_array
    end
  end
end
