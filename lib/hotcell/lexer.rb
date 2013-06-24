
# line 1 "lib/hotcell/lexer.rl"

# line 98 "lib/hotcell/lexer.rl"

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
      @source = Source.wrap(source)
      @data = @source.data
      @encoding = Source::ENCODING
      @pack_mode = Source::PACK_MODE

      
# line 59 "lib/hotcell/lexer.rb"
class << self
	attr_accessor :_puffer_lexer_trans_keys
	private :_puffer_lexer_trans_keys, :_puffer_lexer_trans_keys=
end
self._puffer_lexer_trans_keys = [
	0, 0, 34, 92, 0, 0, 
	125, 125, 38, 38, 39, 
	92, 0, 0, 47, 92, 
	0, 0, 48, 57, 124, 124, 
	125, 125, 123, 123, 123, 
	123, 123, 123, 33, 35, 
	9, 125, 61, 61, 10, 125, 
	42, 42, 48, 57, 47, 
	92, 65, 122, 46, 57, 
	33, 122, 125, 125, 35, 35, 
	35, 35, 125, 125, 0
]

class << self
	attr_accessor :_puffer_lexer_key_spans
	private :_puffer_lexer_key_spans, :_puffer_lexer_key_spans=
end
self._puffer_lexer_key_spans = [
	0, 59, 0, 1, 1, 54, 0, 46, 
	0, 10, 1, 1, 1, 1, 1, 3, 
	117, 1, 116, 1, 10, 46, 58, 12, 
	90, 1, 1, 1, 1
]

class << self
	attr_accessor :_puffer_lexer_index_offsets
	private :_puffer_lexer_index_offsets, :_puffer_lexer_index_offsets=
end
self._puffer_lexer_index_offsets = [
	0, 0, 60, 61, 63, 65, 120, 121, 
	168, 169, 180, 182, 184, 186, 188, 190, 
	194, 312, 314, 431, 433, 444, 491, 550, 
	563, 654, 656, 658, 660
]

class << self
	attr_accessor :_puffer_lexer_indicies
	private :_puffer_lexer_indicies, :_puffer_lexer_indicies=
end
self._puffer_lexer_indicies = [
	1, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 2, 0, 0, 3, 4, 5, 
	6, 8, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 9, 7, 
	7, 12, 11, 11, 11, 11, 11, 11, 
	11, 11, 11, 11, 11, 11, 11, 11, 
	11, 11, 11, 11, 11, 11, 11, 11, 
	11, 11, 11, 11, 11, 11, 11, 11, 
	11, 11, 11, 11, 11, 11, 11, 11, 
	11, 11, 11, 11, 11, 11, 13, 11, 
	11, 15, 15, 15, 15, 15, 15, 15, 
	15, 15, 15, 14, 5, 6, 17, 16, 
	19, 18, 20, 18, 21, 20, 23, 22, 
	23, 22, 24, 5, 24, 24, 24, 6, 
	6, 6, 6, 6, 6, 6, 6, 6, 
	6, 6, 6, 6, 6, 6, 6, 6, 
	6, 24, 25, 0, 4, 6, 5, 26, 
	7, 5, 5, 27, 5, 5, 5, 28, 
	29, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 30, 5, 5, 25, 25, 25, 
	5, 6, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 5, 6, 5, 6, 
	31, 6, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 5, 32, 33, 6, 
	5, 34, 35, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 36, 4, 5, 
	34, 15, 15, 15, 15, 15, 15, 15, 
	15, 15, 15, 37, 12, 11, 11, 11, 
	11, 11, 11, 11, 11, 11, 11, 11, 
	11, 11, 11, 11, 11, 11, 11, 11, 
	11, 11, 11, 11, 11, 11, 11, 11, 
	11, 11, 11, 11, 11, 11, 11, 11, 
	11, 11, 11, 11, 11, 11, 11, 11, 
	11, 13, 11, 12, 12, 12, 12, 12, 
	12, 12, 12, 12, 12, 12, 12, 12, 
	12, 12, 12, 12, 12, 12, 12, 12, 
	12, 12, 12, 12, 12, 38, 38, 38, 
	38, 38, 38, 12, 12, 12, 12, 12, 
	12, 12, 12, 12, 12, 12, 12, 12, 
	12, 12, 12, 12, 12, 12, 12, 12, 
	12, 12, 12, 12, 12, 38, 40, 39, 
	30, 30, 30, 30, 30, 30, 30, 30, 
	30, 30, 39, 42, 41, 41, 41, 41, 
	41, 41, 41, 41, 41, 41, 41, 41, 
	41, 41, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 41, 41, 41, 41, 
	41, 42, 41, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 41, 41, 41, 
	41, 31, 41, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 41, 43, 34, 
	45, 44, 46, 44, 47, 46, 0
]

class << self
	attr_accessor :_puffer_lexer_trans_targs
	private :_puffer_lexer_trans_targs, :_puffer_lexer_trans_targs=
end
self._puffer_lexer_trans_targs = [
	1, 16, 2, 16, 18, 16, 0, 5, 
	16, 6, 16, 7, 22, 8, 16, 20, 
	26, 26, 13, 14, 12, 15, 12, 12, 
	16, 17, 4, 19, 20, 21, 23, 24, 
	10, 25, 16, 16, 3, 16, 16, 16, 
	9, 16, 16, 16, 27, 28, 26, 11
]

class << self
	attr_accessor :_puffer_lexer_trans_actions
	private :_puffer_lexer_trans_actions, :_puffer_lexer_trans_actions=
end
self._puffer_lexer_trans_actions = [
	0, 2, 0, 3, 4, 5, 0, 0, 
	7, 0, 8, 0, 0, 0, 9, 10, 
	11, 12, 0, 0, 15, 0, 16, 17, 
	18, 0, 0, 0, 19, 20, 4, 0, 
	0, 0, 21, 22, 0, 23, 24, 25, 
	0, 26, 27, 28, 0, 4, 29, 0
]

class << self
	attr_accessor :_puffer_lexer_to_state_actions
	private :_puffer_lexer_to_state_actions, :_puffer_lexer_to_state_actions=
end
self._puffer_lexer_to_state_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 13, 0, 0, 0, 
	13, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 13, 0, 0
]

class << self
	attr_accessor :_puffer_lexer_from_state_actions
	private :_puffer_lexer_from_state_actions, :_puffer_lexer_from_state_actions=
end
self._puffer_lexer_from_state_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 14, 0, 0, 0, 
	14, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 14, 0, 0
]

class << self
	attr_accessor :_puffer_lexer_eof_actions
	private :_puffer_lexer_eof_actions, :_puffer_lexer_eof_actions=
end
self._puffer_lexer_eof_actions = [
	0, 1, 0, 0, 0, 6, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0
]

class << self
	attr_accessor :_puffer_lexer_eof_trans
	private :_puffer_lexer_eof_trans, :_puffer_lexer_eof_trans=
end
self._puffer_lexer_eof_trans = [
	0, 0, 0, 4, 0, 0, 0, 11, 
	11, 15, 0, 17, 0, 21, 21, 23, 
	0, 35, 36, 35, 38, 35, 39, 40, 
	42, 35, 0, 47, 47
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


# line 151 "lib/hotcell/lexer.rl"
      #%
    end

    def emit symbol, value
      @token_array << [symbol, [value, @ts]]
    end

    def current_value
      @data[@ts...@te].pack(@pack_mode).force_encoding(@encoding)
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
        SSTRING_ESCAPE_MAP[match] }
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
        last[1][0] += current_value
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
        last[1][0] += current_value
      else
        emit :COMMENT, current_value
      end
    end

    def current_error
      value = @data[@ts..@p].pack(@pack_mode).force_encoding(@encoding)
      [value, *@source.info(@ts).values_at(:line, :column)]
    end

    def raise_unexpected_symbol
      raise Hotcell::UnexpectedSymbol.new *current_error
    end

    def raise_unterminated_string
      raise Hotcell::UnterminatedString.new *current_error
    end

    def raise_unterminated_regexp
      raise Hotcell::UnterminatedRegexp.new *current_error
    end

    def tokens
      @tokens ||= tokenize
    end

    def tokenize
      @token_array = []

      
# line 424 "lib/hotcell/lexer.rb"
begin
	 @p ||= 0
	pe ||=  @data.length
	cs = puffer_lexer_start
	top = 0
	 @ts = nil
	 @te = nil
	act = 0
end

# line 287 "lib/hotcell/lexer.rl"
      #%

      eof = pe
      stack = []

      
# line 442 "lib/hotcell/lexer.rb"
begin
	testEof = false
	_slen, _trans, _keys, _inds, _acts, _nacts = nil
	_goto_level = 0
	_resume = 10
	_eof_trans = 15
	_again = 20
	_test_eof = 30
	_out = 40
	while true
	if _goto_level <= 0
	if  @p == pe
		_goto_level = _test_eof
		next
	end
	if cs == 0
		_goto_level = _out
		next
	end
	end
	if _goto_level <= _resume
	case _puffer_lexer_from_state_actions[cs] 
	when 14 then
# line 1 "NONE"
		begin
 @ts =  @p
		end
# line 470 "lib/hotcell/lexer.rb"
	end
	_keys = cs << 1
	_inds = _puffer_lexer_index_offsets[cs]
	_slen = _puffer_lexer_key_spans[cs]
	_trans = if (   _slen > 0 && 
			_puffer_lexer_trans_keys[_keys] <=  @data[ @p].ord && 
			 @data[ @p].ord <= _puffer_lexer_trans_keys[_keys + 1] 
		    ) then
			_puffer_lexer_indicies[ _inds +  @data[ @p].ord - _puffer_lexer_trans_keys[_keys] ] 
		 else 
			_puffer_lexer_indicies[ _inds + _slen ]
		 end
	end
	if _goto_level <= _eof_trans
	cs = _puffer_lexer_trans_targs[_trans]
	if _puffer_lexer_trans_actions[_trans] != 0
	case _puffer_lexer_trans_actions[_trans]
	when 4 then
# line 1 "NONE"
		begin
 @te =  @p+1
		end
	when 28 then
# line 78 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
 begin  emit_tag; 	begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end
  end
		end
	when 5 then
# line 79 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
 begin  emit_operator  end
		end
	when 27 then
# line 81 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
 begin  emit_identifer  end
		end
	when 7 then
# line 82 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
 begin  emit_sstring  end
		end
	when 2 then
# line 83 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
 begin  emit_dstring  end
		end
	when 18 then
# line 86 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
		end
	when 21 then
# line 79 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_operator  end
		end
	when 25 then
# line 80 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_numeric  end
		end
	when 26 then
# line 81 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_identifer  end
		end
	when 24 then
# line 84 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_regexp  end
		end
	when 22 then
# line 85 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_comment  end
		end
	when 8 then
# line 79 "lib/hotcell/lexer.rl"
		begin
 begin  @p = (( @te))-1; end
 begin  emit_operator  end
		end
	when 9 then
# line 80 "lib/hotcell/lexer.rl"
		begin
 begin  @p = (( @te))-1; end
 begin  emit_numeric  end
		end
	when 3 then
# line 85 "lib/hotcell/lexer.rl"
		begin
 begin  @p = (( @te))-1; end
 begin  emit_comment  end
		end
	when 23 then
# line 1 "NONE"
		begin
	case act
	when 2 then
	begin begin  @p = (( @te))-1; end
 emit_operator end
	when 3 then
	begin begin  @p = (( @te))-1; end
 emit_numeric end
end 
			end
	when 12 then
# line 90 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
 begin  emit_comment; 	begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end
  end
		end
	when 29 then
# line 91 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_comment  end
		end
	when 11 then
# line 91 "lib/hotcell/lexer.rl"
		begin
 begin  @p = (( @te))-1; end
 begin  emit_comment  end
		end
	when 17 then
# line 95 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
 begin  emit_tag_or_comment ->{ 	begin
		stack[top] = cs
		top+= 1
		cs = 16
		_goto_level = _again
		next
	end
 }, ->{ 	begin
		stack[top] = cs
		top+= 1
		cs = 26
		_goto_level = _again
		next
	end
 }  end
		end
	when 16 then
# line 95 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_tag_or_comment ->{ 	begin
		stack[top] = cs
		top+= 1
		cs = 16
		_goto_level = _again
		next
	end
 }, ->{ 	begin
		stack[top] = cs
		top+= 1
		cs = 26
		_goto_level = _again
		next
	end
 }  end
		end
	when 15 then
# line 96 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_template  end
		end
	when 20 then
# line 1 "NONE"
		begin
 @te =  @p+1
		end
# line 59 "lib/hotcell/lexer.rl"
		begin
 regexp_ambiguity { 	begin
		cs = 16
		_goto_level = _again
		next
	end
 } 		end
	when 19 then
# line 1 "NONE"
		begin
 @te =  @p+1
		end
# line 79 "lib/hotcell/lexer.rl"
		begin
act = 2;		end
	when 10 then
# line 1 "NONE"
		begin
 @te =  @p+1
		end
# line 80 "lib/hotcell/lexer.rl"
		begin
act = 3;		end
# line 693 "lib/hotcell/lexer.rb"
	end
	end
	end
	if _goto_level <= _again
	case _puffer_lexer_to_state_actions[cs] 
	when 13 then
# line 1 "NONE"
		begin
 @ts = nil;		end
# line 703 "lib/hotcell/lexer.rb"
	end

	if cs == 0
		_goto_level = _out
		next
	end
	 @p += 1
	if  @p != pe
		_goto_level = _resume
		next
	end
	end
	if _goto_level <= _test_eof
	if  @p == eof
	if _puffer_lexer_eof_trans[cs] > 0
		_trans = _puffer_lexer_eof_trans[cs] - 1;
		_goto_level = _eof_trans
		next;
	end
	  case _puffer_lexer_eof_actions[cs]
	when 6 then
# line 51 "lib/hotcell/lexer.rl"
		begin
 raise_unterminated_string 		end
	when 1 then
# line 55 "lib/hotcell/lexer.rl"
		begin
 raise_unterminated_string 		end
# line 732 "lib/hotcell/lexer.rb"
	  end
	end

	end
	if _goto_level <= _out
		break
	end
end
	end

# line 293 "lib/hotcell/lexer.rl"
      #%

      raise_unexpected_symbol unless @ts.nil?

      @token_array
    end
  end
end
