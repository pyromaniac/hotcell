
# line 1 "lib/hotcell/lexerr.rl"

# line 17 "lib/hotcell/lexerr.rl"


Hotcell::Lexer.class_eval do
  def current_position
    @ts
  end

  def current_value
    @data[@ts...@te].pack(Hotcell::Source::PACK_MODE).force_encoding(@source.encoding)
  end

  def current_error
    value = @data[@ts..@p].pack(Hotcell::Source::PACK_MODE).force_encoding(@source.encoding)
    [value, *@source.info(@ts).values_at(:line, :column)]
  end

  def tokenize
    
# line 24 "lib/hotcell/lexerr.rb"
class << self
	attr_accessor :_puffer_lexer_trans_keys
	private :_puffer_lexer_trans_keys, :_puffer_lexer_trans_keys=
end
self._puffer_lexer_trans_keys = [
	0, 0, 32, 32, 34, 92, 
	0, 0, 125, 125, 38, 
	38, 39, 92, 0, 0, 
	48, 57, 47, 92, 0, 0, 
	124, 124, 125, 125, 123, 
	123, 123, 123, 123, 123, 
	33, 126, 9, 125, 61, 61, 
	10, 125, 42, 42, 46, 
	57, 48, 57, 47, 92, 
	65, 122, 33, 122, 125, 125, 
	35, 35, 35, 35, 125, 
	125, 0
]

class << self
	attr_accessor :_puffer_lexer_key_spans
	private :_puffer_lexer_key_spans, :_puffer_lexer_key_spans=
end
self._puffer_lexer_key_spans = [
	0, 1, 59, 0, 1, 1, 54, 0, 
	10, 46, 0, 1, 1, 1, 1, 1, 
	94, 117, 1, 116, 1, 12, 10, 46, 
	58, 90, 1, 1, 1, 1
]

class << self
	attr_accessor :_puffer_lexer_index_offsets
	private :_puffer_lexer_index_offsets, :_puffer_lexer_index_offsets=
end
self._puffer_lexer_index_offsets = [
	0, 0, 2, 62, 63, 65, 67, 122, 
	123, 134, 181, 182, 184, 186, 188, 190, 
	192, 287, 405, 407, 524, 526, 539, 550, 
	597, 656, 747, 749, 751, 753
]

class << self
	attr_accessor :_puffer_lexer_indicies
	private :_puffer_lexer_indicies, :_puffer_lexer_indicies=
end
self._puffer_lexer_indicies = [
	1, 0, 3, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 4, 2, 2, 5, 
	6, 7, 8, 10, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	11, 9, 9, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 12, 16, 15, 
	15, 15, 15, 15, 15, 15, 15, 15, 
	15, 15, 15, 15, 15, 15, 15, 15, 
	15, 15, 15, 15, 15, 15, 15, 15, 
	15, 15, 15, 15, 15, 15, 15, 15, 
	15, 15, 15, 15, 15, 15, 15, 15, 
	15, 15, 15, 17, 15, 15, 7, 8, 
	19, 18, 21, 20, 22, 20, 23, 22, 
	1, 24, 25, 24, 24, 24, 24, 24, 
	24, 24, 24, 24, 24, 24, 24, 24, 
	24, 24, 24, 24, 24, 24, 24, 24, 
	24, 24, 24, 24, 24, 24, 24, 24, 
	24, 24, 24, 24, 24, 24, 24, 24, 
	24, 24, 24, 24, 24, 24, 24, 24, 
	24, 24, 24, 24, 24, 24, 24, 24, 
	24, 24, 24, 24, 24, 1, 24, 24, 
	24, 24, 24, 24, 26, 24, 24, 24, 
	24, 24, 24, 24, 24, 24, 24, 24, 
	24, 26, 24, 24, 24, 24, 24, 24, 
	24, 24, 24, 24, 24, 1, 24, 27, 
	7, 27, 27, 27, 8, 8, 8, 8, 
	8, 8, 8, 8, 8, 8, 8, 8, 
	8, 8, 8, 8, 8, 8, 27, 28, 
	2, 6, 8, 7, 29, 9, 7, 7, 
	30, 7, 7, 31, 32, 33, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	7, 7, 28, 28, 28, 7, 8, 35, 
	35, 35, 35, 35, 35, 35, 35, 35, 
	35, 35, 35, 35, 35, 35, 35, 35, 
	35, 35, 35, 35, 35, 35, 35, 35, 
	35, 7, 8, 7, 8, 35, 8, 35, 
	35, 35, 35, 35, 35, 35, 35, 35, 
	35, 35, 35, 35, 35, 35, 35, 35, 
	35, 35, 35, 35, 35, 35, 35, 35, 
	35, 7, 36, 37, 8, 7, 38, 39, 
	6, 6, 6, 6, 6, 6, 6, 6, 
	6, 6, 6, 6, 6, 6, 6, 6, 
	6, 6, 6, 6, 6, 6, 6, 6, 
	6, 6, 6, 6, 6, 6, 6, 6, 
	6, 6, 6, 6, 6, 6, 6, 6, 
	6, 6, 6, 6, 6, 6, 6, 6, 
	6, 6, 6, 6, 6, 6, 6, 6, 
	6, 6, 6, 6, 6, 6, 6, 6, 
	6, 6, 6, 6, 6, 6, 6, 6, 
	6, 6, 6, 6, 6, 6, 6, 6, 
	6, 6, 6, 6, 6, 6, 6, 6, 
	6, 6, 6, 6, 6, 6, 6, 6, 
	6, 6, 6, 6, 6, 6, 6, 6, 
	6, 6, 6, 6, 6, 6, 6, 6, 
	6, 6, 40, 6, 7, 38, 41, 12, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 12, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 12, 16, 15, 
	15, 15, 15, 15, 15, 15, 15, 15, 
	15, 15, 15, 15, 15, 15, 15, 15, 
	15, 15, 15, 15, 15, 15, 15, 15, 
	15, 15, 15, 15, 15, 15, 15, 15, 
	15, 15, 15, 15, 15, 15, 15, 15, 
	15, 15, 15, 17, 15, 16, 16, 16, 
	16, 16, 16, 16, 16, 16, 16, 16, 
	16, 16, 16, 16, 16, 16, 16, 16, 
	16, 16, 16, 16, 16, 16, 16, 42, 
	42, 42, 42, 42, 42, 16, 16, 16, 
	16, 16, 16, 16, 16, 16, 16, 16, 
	16, 16, 16, 16, 16, 16, 16, 16, 
	16, 16, 16, 16, 16, 16, 16, 42, 
	44, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 35, 
	35, 35, 35, 35, 35, 35, 35, 35, 
	35, 43, 43, 43, 43, 43, 44, 43, 
	35, 35, 35, 35, 35, 35, 35, 35, 
	35, 35, 35, 35, 35, 35, 35, 35, 
	35, 35, 35, 35, 35, 35, 35, 35, 
	35, 35, 43, 43, 43, 43, 35, 43, 
	35, 35, 35, 35, 35, 35, 35, 35, 
	35, 35, 35, 35, 35, 35, 35, 35, 
	35, 35, 35, 35, 35, 35, 35, 35, 
	35, 35, 43, 45, 38, 47, 46, 48, 
	46, 49, 48, 0
]

class << self
	attr_accessor :_puffer_lexer_trans_targs
	private :_puffer_lexer_trans_targs, :_puffer_lexer_trans_targs=
end
self._puffer_lexer_trans_targs = [
	13, 13, 2, 17, 3, 17, 19, 17, 
	0, 6, 17, 7, 17, 22, 17, 9, 
	24, 10, 27, 27, 14, 15, 13, 16, 
	13, 13, 1, 17, 18, 5, 20, 21, 
	22, 23, 21, 25, 11, 26, 17, 17, 
	4, 8, 17, 17, 17, 17, 28, 29, 
	27, 12
]

class << self
	attr_accessor :_puffer_lexer_trans_actions
	private :_puffer_lexer_trans_actions, :_puffer_lexer_trans_actions=
end
self._puffer_lexer_trans_actions = [
	1, 2, 0, 4, 0, 5, 6, 7, 
	0, 0, 9, 0, 10, 11, 12, 0, 
	0, 0, 13, 14, 0, 0, 17, 6, 
	18, 19, 0, 20, 0, 0, 0, 21, 
	21, 22, 11, 0, 0, 0, 23, 24, 
	0, 0, 25, 26, 27, 28, 0, 6, 
	29, 0
]

class << self
	attr_accessor :_puffer_lexer_to_state_actions
	private :_puffer_lexer_to_state_actions, :_puffer_lexer_to_state_actions=
end
self._puffer_lexer_to_state_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 15, 0, 0, 
	0, 15, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 15, 0, 0
]

class << self
	attr_accessor :_puffer_lexer_from_state_actions
	private :_puffer_lexer_from_state_actions, :_puffer_lexer_from_state_actions=
end
self._puffer_lexer_from_state_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 16, 0, 0, 
	0, 16, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 16, 0, 0
]

class << self
	attr_accessor :_puffer_lexer_eof_actions
	private :_puffer_lexer_eof_actions, :_puffer_lexer_eof_actions=
end
self._puffer_lexer_eof_actions = [
	0, 0, 3, 0, 0, 0, 8, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0
]

class << self
	attr_accessor :_puffer_lexer_eof_trans
	private :_puffer_lexer_eof_trans, :_puffer_lexer_eof_trans=
end
self._puffer_lexer_eof_trans = [
	0, 1, 0, 0, 6, 0, 0, 0, 
	13, 15, 15, 0, 19, 0, 23, 23, 
	25, 0, 39, 40, 39, 13, 13, 39, 
	43, 44, 39, 0, 49, 49
]

class << self
	attr_accessor :puffer_lexer_start
end
self.puffer_lexer_start = 13;
class << self
	attr_accessor :puffer_lexer_first_final
end
self.puffer_lexer_first_final = 13;
class << self
	attr_accessor :puffer_lexer_error
end
self.puffer_lexer_error = 0;

class << self
	attr_accessor :puffer_lexer_en_expression
end
self.puffer_lexer_en_expression = 17;
class << self
	attr_accessor :puffer_lexer_en_template_comment
end
self.puffer_lexer_en_template_comment = 27;
class << self
	attr_accessor :puffer_lexer_en_main
end
self.puffer_lexer_en_main = 13;


# line 35 "lib/hotcell/lexerr.rl"
    #%

    @data = @source.data
    @token_array = []

    
# line 274 "lib/hotcell/lexerr.rb"
begin
	 @p ||= 0
	pe ||=  @data.length
	cs = puffer_lexer_start
	top = 0
	 @ts = nil
	 @te = nil
	act = 0
end

# line 41 "lib/hotcell/lexerr.rl"
    #%

    eof = pe
    stack = []

    
# line 292 "lib/hotcell/lexerr.rb"
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
	when 16 then
# line 1 "NONE"
		begin
 @ts =  @p
		end
# line 320 "lib/hotcell/lexerr.rb"
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
	when 6 then
# line 1 "NONE"
		begin
 @te =  @p+1
		end
	when 28 then
# line 73 "lib/hotcell/lexer.rl"
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
	when 7 then
# line 74 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
 begin  emit_operator;  end
		end
	when 27 then
# line 76 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
 begin  emit_identifer;  end
		end
	when 9 then
# line 77 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
 begin  emit_sstring;  end
		end
	when 4 then
# line 78 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
 begin  emit_dstring;  end
		end
	when 20 then
# line 81 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
		end
	when 23 then
# line 74 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_operator;  end
		end
	when 26 then
# line 76 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_identifer;  end
		end
	when 25 then
# line 79 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_regexp;  end
		end
	when 24 then
# line 80 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_comment;  end
		end
	when 12 then
# line 74 "lib/hotcell/lexer.rl"
		begin
 begin  @p = (( @te))-1; end
 begin  emit_operator;  end
		end
	when 5 then
# line 80 "lib/hotcell/lexer.rl"
		begin
 begin  @p = (( @te))-1; end
 begin  emit_comment;  end
		end
	when 10 then
# line 1 "NONE"
		begin
	case act
	when 2 then
	begin begin  @p = (( @te))-1; end
 emit_operator; end
	when 3 then
	begin begin  @p = (( @te))-1; end
 emit_numeric; end
end 
			end
	when 14 then
# line 85 "lib/hotcell/lexer.rl"
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
# line 86 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_comment;  end
		end
	when 13 then
# line 86 "lib/hotcell/lexer.rl"
		begin
 begin  @p = (( @te))-1; end
 begin  emit_comment;  end
		end
	when 2 then
# line 90 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
 begin  emit_tag; 	begin
		stack[top] = cs
		top+= 1
		cs = 17
		_goto_level = _again
		next
	end
  end
		end
	when 19 then
# line 91 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
 begin  emit_comment; 	begin
		stack[top] = cs
		top+= 1
		cs = 27
		_goto_level = _again
		next
	end
  end
		end
	when 18 then
# line 90 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_tag; 	begin
		stack[top] = cs
		top+= 1
		cs = 17
		_goto_level = _again
		next
	end
  end
		end
	when 17 then
# line 92 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_template;  end
		end
	when 1 then
# line 90 "lib/hotcell/lexer.rl"
		begin
 begin  @p = (( @te))-1; end
 begin  emit_tag; 	begin
		stack[top] = cs
		top+= 1
		cs = 17
		_goto_level = _again
		next
	end
  end
		end
	when 22 then
# line 1 "NONE"
		begin
 @te =  @p+1
		end
# line 9 "lib/hotcell/lexerr.rl"
		begin

    if (!regexp_possible)
      emit_operator;
      	begin
		cs = 17
		_goto_level = _again
		next
	end

    end
  		end
	when 21 then
# line 1 "NONE"
		begin
 @te =  @p+1
		end
# line 74 "lib/hotcell/lexer.rl"
		begin
act = 2;		end
	when 11 then
# line 1 "NONE"
		begin
 @te =  @p+1
		end
# line 75 "lib/hotcell/lexer.rl"
		begin
act = 3;		end
# line 548 "lib/hotcell/lexerr.rb"
	end
	end
	end
	if _goto_level <= _again
	case _puffer_lexer_to_state_actions[cs] 
	when 15 then
# line 1 "NONE"
		begin
 @ts = nil;		end
# line 558 "lib/hotcell/lexerr.rb"
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
	when 8 then
# line 45 "lib/hotcell/lexer.rl"
		begin
 raise_unterminated_string; 		end
	when 3 then
# line 49 "lib/hotcell/lexer.rl"
		begin
 raise_unterminated_string; 		end
# line 587 "lib/hotcell/lexerr.rb"
	  end
	end

	end
	if _goto_level <= _out
		break
	end
end
	end

# line 47 "lib/hotcell/lexerr.rl"
    #%

    raise_unexpected_symbol unless @ts.nil?

    @token_array
  end
end
