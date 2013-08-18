
# line 1 "lib/hotcell/lexerr.rl"

# line 44 "lib/hotcell/lexerr.rl"


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
	attr_accessor :_hotcell_lexer_trans_keys
	private :_hotcell_lexer_trans_keys, :_hotcell_lexer_trans_keys=
end
self._hotcell_lexer_trans_keys = [
	0, 0, 32, 32, 0, 0, 
	38, 38, 39, 92, 0, 
	0, 48, 57, 47, 92, 
	0, 0, 124, 124, 125, 125, 
	38, 38, 39, 92, 0, 
	0, 48, 57, 47, 92, 
	0, 0, 124, 124, 125, 125, 
	123, 123, 123, 123, 123, 
	123, 33, 126, 34, 92, 
	34, 92, 123, 123, 9, 125, 
	61, 61, 34, 34, 42, 
	42, 46, 57, 48, 57, 
	46, 57, 46, 46, 47, 92, 
	65, 122, 33, 122, 9, 
	125, 61, 61, 34, 34, 
	10, 125, 42, 42, 46, 57, 
	48, 57, 46, 57, 46, 
	46, 47, 92, 65, 122, 
	33, 122, 125, 125, 35, 35, 
	35, 35, 125, 125, 0
]

class << self
	attr_accessor :_hotcell_lexer_key_spans
	private :_hotcell_lexer_key_spans, :_hotcell_lexer_key_spans=
end
self._hotcell_lexer_key_spans = [
	0, 1, 0, 1, 54, 0, 10, 46, 
	0, 1, 1, 1, 54, 0, 10, 46, 
	0, 1, 1, 1, 1, 1, 94, 59, 
	59, 1, 117, 1, 1, 1, 12, 10, 
	12, 1, 46, 58, 90, 117, 1, 1, 
	116, 1, 12, 10, 12, 1, 46, 58, 
	90, 1, 1, 1, 1
]

class << self
	attr_accessor :_hotcell_lexer_index_offsets
	private :_hotcell_lexer_index_offsets, :_hotcell_lexer_index_offsets=
end
self._hotcell_lexer_index_offsets = [
	0, 0, 2, 3, 5, 60, 61, 72, 
	119, 120, 122, 124, 126, 181, 182, 193, 
	240, 241, 243, 245, 247, 249, 251, 346, 
	406, 466, 468, 586, 588, 590, 592, 605, 
	616, 629, 631, 678, 737, 828, 946, 948, 
	950, 1067, 1069, 1082, 1093, 1106, 1108, 1155, 
	1214, 1305, 1307, 1309, 1311
]

class << self
	attr_accessor :_hotcell_lexer_indicies
	private :_hotcell_lexer_indicies, :_hotcell_lexer_indicies=
end
self._hotcell_lexer_indicies = [
	1, 0, 3, 4, 5, 7, 6, 6, 
	6, 6, 6, 6, 6, 6, 6, 6, 
	6, 6, 6, 6, 6, 6, 6, 6, 
	6, 6, 6, 6, 6, 6, 6, 6, 
	6, 6, 6, 6, 6, 6, 6, 6, 
	6, 6, 6, 6, 6, 6, 6, 6, 
	6, 6, 6, 6, 6, 6, 6, 6, 
	6, 6, 8, 6, 6, 10, 10, 10, 
	10, 10, 10, 10, 10, 10, 10, 9, 
	13, 12, 12, 12, 12, 12, 12, 12, 
	12, 12, 12, 12, 12, 12, 12, 12, 
	12, 12, 12, 12, 12, 12, 12, 12, 
	12, 12, 12, 12, 12, 12, 12, 12, 
	12, 12, 12, 12, 12, 12, 12, 12, 
	12, 12, 12, 12, 12, 14, 12, 12, 
	4, 5, 15, 16, 17, 5, 19, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 20, 18, 18, 22, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	21, 25, 24, 24, 24, 24, 24, 24, 
	24, 24, 24, 24, 24, 24, 24, 24, 
	24, 24, 24, 24, 24, 24, 24, 24, 
	24, 24, 24, 24, 24, 24, 24, 24, 
	24, 24, 24, 24, 24, 24, 24, 24, 
	24, 24, 24, 24, 24, 24, 26, 24, 
	24, 17, 5, 28, 27, 30, 29, 31, 
	29, 32, 31, 1, 33, 34, 33, 33, 
	33, 33, 33, 33, 33, 33, 33, 33, 
	33, 33, 33, 33, 33, 33, 33, 33, 
	33, 33, 33, 33, 33, 33, 33, 33, 
	33, 33, 33, 33, 33, 33, 33, 33, 
	33, 33, 33, 33, 33, 33, 33, 33, 
	33, 33, 33, 33, 33, 33, 33, 33, 
	33, 33, 33, 33, 33, 33, 33, 33, 
	1, 33, 33, 33, 33, 33, 33, 35, 
	33, 33, 33, 33, 33, 33, 33, 33, 
	33, 33, 33, 33, 35, 33, 33, 33, 
	33, 33, 33, 33, 33, 33, 33, 33, 
	1, 33, 36, 37, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 38, 3, 39, 39, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	38, 3, 40, 39, 41, 4, 41, 41, 
	41, 5, 5, 5, 5, 5, 5, 5, 
	5, 5, 5, 5, 5, 5, 5, 5, 
	5, 5, 5, 41, 42, 43, 5, 5, 
	4, 44, 6, 4, 4, 45, 4, 4, 
	46, 47, 48, 49, 49, 49, 49, 49, 
	49, 49, 49, 49, 49, 4, 4, 42, 
	42, 42, 4, 5, 50, 50, 50, 50, 
	50, 50, 50, 50, 50, 50, 50, 50, 
	50, 50, 50, 50, 50, 50, 50, 50, 
	50, 50, 50, 50, 50, 50, 4, 5, 
	4, 5, 50, 5, 50, 50, 50, 50, 
	50, 50, 50, 50, 50, 50, 50, 50, 
	50, 50, 50, 50, 50, 50, 50, 50, 
	50, 50, 50, 50, 50, 50, 51, 52, 
	53, 5, 4, 54, 7, 55, 4, 54, 
	56, 9, 49, 49, 49, 49, 49, 49, 
	49, 49, 49, 49, 9, 10, 10, 10, 
	10, 10, 10, 10, 10, 10, 10, 57, 
	58, 54, 10, 10, 10, 10, 10, 10, 
	10, 10, 10, 10, 54, 4, 54, 13, 
	12, 12, 12, 12, 12, 12, 12, 12, 
	12, 12, 12, 12, 12, 12, 12, 12, 
	12, 12, 12, 12, 12, 12, 12, 12, 
	12, 12, 12, 12, 12, 12, 12, 12, 
	12, 12, 12, 12, 12, 12, 12, 12, 
	12, 12, 12, 12, 14, 12, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	59, 59, 59, 59, 59, 59, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	59, 61, 60, 60, 60, 60, 60, 60, 
	60, 60, 60, 60, 60, 60, 60, 60, 
	50, 50, 50, 50, 50, 50, 50, 50, 
	50, 50, 60, 60, 60, 60, 60, 61, 
	60, 50, 50, 50, 50, 50, 50, 50, 
	50, 50, 50, 50, 50, 50, 50, 50, 
	50, 50, 50, 50, 50, 50, 50, 50, 
	50, 50, 50, 60, 60, 60, 60, 50, 
	60, 50, 50, 50, 50, 50, 50, 50, 
	50, 50, 50, 50, 50, 50, 50, 50, 
	50, 50, 50, 50, 50, 50, 50, 50, 
	50, 50, 50, 60, 62, 17, 62, 62, 
	62, 5, 5, 5, 5, 5, 5, 5, 
	5, 5, 5, 5, 5, 5, 5, 5, 
	5, 5, 5, 62, 63, 64, 16, 5, 
	17, 65, 18, 17, 17, 66, 17, 17, 
	67, 68, 69, 70, 70, 70, 70, 70, 
	70, 70, 70, 70, 70, 17, 17, 63, 
	63, 63, 17, 5, 71, 71, 71, 71, 
	71, 71, 71, 71, 71, 71, 71, 71, 
	71, 71, 71, 71, 71, 71, 71, 71, 
	71, 71, 71, 71, 71, 71, 17, 5, 
	17, 5, 71, 5, 71, 71, 71, 71, 
	71, 71, 71, 71, 71, 71, 71, 71, 
	71, 71, 71, 71, 71, 71, 71, 71, 
	71, 71, 71, 71, 71, 71, 17, 72, 
	73, 5, 17, 74, 19, 75, 76, 16, 
	16, 16, 16, 16, 16, 16, 16, 16, 
	16, 16, 16, 16, 16, 16, 16, 16, 
	16, 16, 16, 16, 16, 16, 16, 16, 
	16, 16, 16, 16, 16, 16, 16, 16, 
	16, 16, 16, 16, 16, 16, 16, 16, 
	16, 16, 16, 16, 16, 16, 16, 16, 
	16, 16, 16, 16, 16, 16, 16, 16, 
	16, 16, 16, 16, 16, 16, 16, 16, 
	16, 16, 16, 16, 16, 16, 16, 16, 
	16, 16, 16, 16, 16, 16, 16, 16, 
	16, 16, 16, 16, 16, 16, 16, 16, 
	16, 16, 16, 16, 16, 16, 16, 16, 
	16, 16, 16, 16, 16, 16, 16, 16, 
	16, 16, 16, 16, 16, 16, 16, 16, 
	16, 77, 16, 17, 74, 78, 21, 70, 
	70, 70, 70, 70, 70, 70, 70, 70, 
	70, 21, 22, 22, 22, 22, 22, 22, 
	22, 22, 22, 22, 79, 80, 74, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	22, 74, 17, 74, 25, 24, 24, 24, 
	24, 24, 24, 24, 24, 24, 24, 24, 
	24, 24, 24, 24, 24, 24, 24, 24, 
	24, 24, 24, 24, 24, 24, 24, 24, 
	24, 24, 24, 24, 24, 24, 24, 24, 
	24, 24, 24, 24, 24, 24, 24, 24, 
	24, 26, 24, 25, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 81, 81, 81, 
	81, 81, 81, 25, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 81, 83, 82, 
	82, 82, 82, 82, 82, 82, 82, 82, 
	82, 82, 82, 82, 82, 71, 71, 71, 
	71, 71, 71, 71, 71, 71, 71, 82, 
	82, 82, 82, 82, 83, 82, 71, 71, 
	71, 71, 71, 71, 71, 71, 71, 71, 
	71, 71, 71, 71, 71, 71, 71, 71, 
	71, 71, 71, 71, 71, 71, 71, 71, 
	82, 82, 82, 82, 71, 82, 71, 71, 
	71, 71, 71, 71, 71, 71, 71, 71, 
	71, 71, 71, 71, 71, 71, 71, 71, 
	71, 71, 71, 71, 71, 71, 71, 71, 
	82, 84, 74, 86, 85, 87, 85, 88, 
	87, 0
]

class << self
	attr_accessor :_hotcell_lexer_trans_targs
	private :_hotcell_lexer_trans_targs, :_hotcell_lexer_trans_targs=
end
self._hotcell_lexer_trans_targs = [
	19, 19, 23, 24, 26, 0, 4, 26, 
	5, 26, 31, 26, 7, 35, 8, 37, 
	40, 37, 12, 37, 13, 37, 43, 37, 
	15, 47, 16, 50, 50, 20, 21, 19, 
	22, 19, 19, 1, 23, 25, 2, 23, 
	23, 26, 27, 28, 3, 29, 30, 32, 
	34, 30, 36, 26, 9, 26, 26, 26, 
	6, 26, 33, 26, 26, 26, 37, 38, 
	39, 11, 41, 42, 44, 46, 42, 48, 
	17, 49, 37, 37, 37, 10, 14, 37, 
	45, 37, 37, 37, 37, 51, 52, 50, 
	18
]

class << self
	attr_accessor :_hotcell_lexer_trans_actions
	private :_hotcell_lexer_trans_actions, :_hotcell_lexer_trans_actions=
end
self._hotcell_lexer_trans_actions = [
	1, 2, 3, 4, 5, 0, 0, 7, 
	0, 8, 0, 9, 0, 0, 0, 10, 
	11, 12, 0, 13, 0, 14, 0, 15, 
	0, 0, 0, 16, 17, 0, 0, 20, 
	11, 21, 22, 0, 24, 0, 0, 25, 
	26, 27, 0, 0, 0, 0, 28, 0, 
	29, 30, 0, 31, 0, 32, 33, 34, 
	0, 35, 0, 36, 37, 38, 39, 0, 
	0, 0, 0, 40, 0, 29, 41, 0, 
	0, 0, 42, 43, 44, 0, 0, 45, 
	0, 46, 47, 48, 49, 0, 11, 50, 
	0
]

class << self
	attr_accessor :_hotcell_lexer_to_state_actions
	private :_hotcell_lexer_to_state_actions, :_hotcell_lexer_to_state_actions=
end
self._hotcell_lexer_to_state_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 18, 0, 0, 0, 23, 
	0, 0, 18, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 18, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 18, 0, 0
]

class << self
	attr_accessor :_hotcell_lexer_from_state_actions
	private :_hotcell_lexer_from_state_actions, :_hotcell_lexer_from_state_actions=
end
self._hotcell_lexer_from_state_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 19, 0, 0, 0, 19, 
	0, 0, 19, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 19, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 19, 0, 0
]

class << self
	attr_accessor :_hotcell_lexer_eof_actions
	private :_hotcell_lexer_eof_actions, :_hotcell_lexer_eof_actions=
end
self._hotcell_lexer_eof_actions = [
	0, 0, 0, 0, 6, 0, 0, 0, 
	0, 0, 0, 0, 6, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0
]

class << self
	attr_accessor :_hotcell_lexer_eof_trans
	private :_hotcell_lexer_eof_trans, :_hotcell_lexer_eof_trans=
end
self._hotcell_lexer_eof_trans = [
	0, 1, 3, 0, 0, 0, 10, 12, 
	12, 0, 16, 0, 0, 0, 22, 24, 
	24, 0, 28, 0, 32, 32, 34, 0, 
	40, 40, 0, 55, 56, 55, 10, 58, 
	55, 55, 55, 60, 61, 0, 75, 76, 
	77, 75, 22, 80, 75, 75, 75, 82, 
	83, 75, 0, 88, 88
]

class << self
	attr_accessor :hotcell_lexer_start
end
self.hotcell_lexer_start = 19;
class << self
	attr_accessor :hotcell_lexer_first_final
end
self.hotcell_lexer_first_final = 19;
class << self
	attr_accessor :hotcell_lexer_error
end
self.hotcell_lexer_error = 0;

class << self
	attr_accessor :hotcell_lexer_en_dstring
end
self.hotcell_lexer_en_dstring = 23;
class << self
	attr_accessor :hotcell_lexer_en_interpolation
end
self.hotcell_lexer_en_interpolation = 26;
class << self
	attr_accessor :hotcell_lexer_en_expression
end
self.hotcell_lexer_en_expression = 37;
class << self
	attr_accessor :hotcell_lexer_en_template_comment
end
self.hotcell_lexer_en_template_comment = 50;
class << self
	attr_accessor :hotcell_lexer_en_main
end
self.hotcell_lexer_en_main = 19;


# line 62 "lib/hotcell/lexerr.rl"
    #%

    @data = @source.data
    @token_array = []

    
# line 388 "lib/hotcell/lexerr.rb"
begin
	 @p ||= 0
	pe ||=  @data.length
	cs = hotcell_lexer_start
	top = 0
	 @ts = nil
	 @te = nil
	act = 0
end

# line 68 "lib/hotcell/lexerr.rl"
    #%

    eof = pe
    stack = []

    
# line 406 "lib/hotcell/lexerr.rb"
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
	case _hotcell_lexer_from_state_actions[cs] 
	when 19 then
# line 1 "NONE"
		begin
 @ts =  @p
		end
# line 434 "lib/hotcell/lexerr.rb"
	end
	_keys = cs << 1
	_inds = _hotcell_lexer_index_offsets[cs]
	_slen = _hotcell_lexer_key_spans[cs]
	_trans = if (   _slen > 0 && 
			_hotcell_lexer_trans_keys[_keys] <=  @data[ @p].ord && 
			 @data[ @p].ord <= _hotcell_lexer_trans_keys[_keys + 1] 
		    ) then
			_hotcell_lexer_indicies[ _inds +  @data[ @p].ord - _hotcell_lexer_trans_keys[_keys] ] 
		 else 
			_hotcell_lexer_indicies[ _inds + _slen ]
		 end
	end
	if _goto_level <= _eof_trans
	cs = _hotcell_lexer_trans_targs[_trans]
	if _hotcell_lexer_trans_actions[_trans] != 0
	case _hotcell_lexer_trans_actions[_trans]
	when 11 then
# line 1 "NONE"
		begin
 @te =  @p+1
		end
	when 24 then
# line 73 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
 begin  emit_dstring_close; 	begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end
  end
		end
	when 26 then
# line 16 "lib/hotcell/lexerr.rl"
		begin
 @te =  @p+1
 begin 
    @braces_count = 0;
    emit_interpolation
    	begin
		stack[top] = cs
		top+= 1
		cs = 26
		_goto_level = _again
		next
	end

   end
		end
	when 25 then
# line 75 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_dstring;  end
		end
	when 3 then
# line 1 "NONE"
		begin
	case act
	when 0 then
	begin	begin
		cs = 0
		_goto_level = _again
		next
	end
end
	when 3 then
	begin begin  @p = (( @te))-1; end
 emit_dstring; end
end 
			end
	when 5 then
# line 81 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
 begin  emit_operator;  end
		end
	when 31 then
# line 22 "lib/hotcell/lexerr.rl"
		begin
 @te =  @p+1
 begin 
    emit_operator
    @braces_count += 1
   end
		end
	when 32 then
# line 27 "lib/hotcell/lexerr.rl"
		begin
 @te =  @p+1
 begin 
    if @braces_count < 1
      emit_interpolation
      	begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end

    else
      emit_operator
      @braces_count -= 1
    end
   end
		end
	when 38 then
# line 86 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
 begin  emit_identifer;  end
		end
	when 7 then
# line 87 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
 begin  emit_string;  end
		end
	when 27 then
# line 89 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
		end
	when 33 then
# line 81 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_operator;  end
		end
	when 34 then
# line 37 "lib/hotcell/lexerr.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin 
    @dstring_start = @ts
    emit_dstring_open
    	begin
		stack[top] = cs
		top+= 1
		cs = 23
		_goto_level = _again
		next
	end

   end
		end
	when 35 then
# line 85 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_numeric;  end
		end
	when 37 then
# line 86 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_identifer;  end
		end
	when 36 then
# line 88 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_regexp;  end
		end
	when 9 then
# line 81 "lib/hotcell/lexer.rl"
		begin
 begin  @p = (( @te))-1; end
 begin  emit_operator;  end
		end
	when 8 then
# line 1 "NONE"
		begin
	case act
	when 4 then
	begin begin  @p = (( @te))-1; end
 emit_operator; end
	when 8 then
	begin begin  @p = (( @te))-1; end
 emit_numeric; end
end 
			end
	when 49 then
# line 93 "lib/hotcell/lexer.rl"
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
	when 12 then
# line 95 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
 begin  emit_operator;  end
		end
	when 48 then
# line 97 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
 begin  emit_identifer;  end
		end
	when 13 then
# line 98 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
 begin  emit_string;  end
		end
	when 39 then
# line 101 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
		end
	when 43 then
# line 37 "lib/hotcell/lexerr.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin 
    @dstring_start = @ts
    emit_dstring_open
    	begin
		stack[top] = cs
		top+= 1
		cs = 23
		_goto_level = _again
		next
	end

   end
		end
	when 42 then
# line 95 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_operator;  end
		end
	when 45 then
# line 96 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_numeric;  end
		end
	when 47 then
# line 97 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_identifer;  end
		end
	when 46 then
# line 99 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_regexp;  end
		end
	when 44 then
# line 100 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_comment;  end
		end
	when 15 then
# line 95 "lib/hotcell/lexer.rl"
		begin
 begin  @p = (( @te))-1; end
 begin  emit_operator;  end
		end
	when 10 then
# line 100 "lib/hotcell/lexer.rl"
		begin
 begin  @p = (( @te))-1; end
 begin  emit_comment;  end
		end
	when 14 then
# line 1 "NONE"
		begin
	case act
	when 15 then
	begin begin  @p = (( @te))-1; end
 emit_operator; end
	when 16 then
	begin begin  @p = (( @te))-1; end
 emit_numeric; end
end 
			end
	when 17 then
# line 105 "lib/hotcell/lexer.rl"
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
	when 50 then
# line 106 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_comment;  end
		end
	when 16 then
# line 106 "lib/hotcell/lexer.rl"
		begin
 begin  @p = (( @te))-1; end
 begin  emit_comment;  end
		end
	when 2 then
# line 110 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
 begin  emit_tag; 	begin
		stack[top] = cs
		top+= 1
		cs = 37
		_goto_level = _again
		next
	end
  end
		end
	when 22 then
# line 111 "lib/hotcell/lexer.rl"
		begin
 @te =  @p+1
 begin  emit_comment; 	begin
		stack[top] = cs
		top+= 1
		cs = 50
		_goto_level = _again
		next
	end
  end
		end
	when 21 then
# line 110 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_tag; 	begin
		stack[top] = cs
		top+= 1
		cs = 37
		_goto_level = _again
		next
	end
  end
		end
	when 20 then
# line 112 "lib/hotcell/lexer.rl"
		begin
 @te =  @p
 @p =  @p - 1; begin  emit_template;  end
		end
	when 1 then
# line 110 "lib/hotcell/lexer.rl"
		begin
 begin  @p = (( @te))-1; end
 begin  emit_tag; 	begin
		stack[top] = cs
		top+= 1
		cs = 37
		_goto_level = _again
		next
	end
  end
		end
	when 29 then
# line 1 "NONE"
		begin
 @te =  @p+1
		end
# line 9 "lib/hotcell/lexerr.rl"
		begin

    if (!regexp_possible)
      emit_operator;
      	begin
		cs = 37
		_goto_level = _again
		next
	end

    end
  		end
	when 4 then
# line 1 "NONE"
		begin
 @te =  @p+1
		end
# line 75 "lib/hotcell/lexer.rl"
		begin
act = 3;		end
	when 28 then
# line 1 "NONE"
		begin
 @te =  @p+1
		end
# line 81 "lib/hotcell/lexer.rl"
		begin
act = 4;		end
	when 30 then
# line 1 "NONE"
		begin
 @te =  @p+1
		end
# line 85 "lib/hotcell/lexer.rl"
		begin
act = 8;		end
	when 40 then
# line 1 "NONE"
		begin
 @te =  @p+1
		end
# line 95 "lib/hotcell/lexer.rl"
		begin
act = 15;		end
	when 41 then
# line 1 "NONE"
		begin
 @te =  @p+1
		end
# line 96 "lib/hotcell/lexer.rl"
		begin
act = 16;		end
# line 865 "lib/hotcell/lexerr.rb"
	end
	end
	end
	if _goto_level <= _again
	case _hotcell_lexer_to_state_actions[cs] 
	when 18 then
# line 1 "NONE"
		begin
 @ts = nil;		end
	when 23 then
# line 1 "NONE"
		begin
 @ts = nil;		end
# line 1 "NONE"
		begin
act = 0
		end
# line 883 "lib/hotcell/lexerr.rb"
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
	if _hotcell_lexer_eof_trans[cs] > 0
		_trans = _hotcell_lexer_eof_trans[cs] - 1;
		_goto_level = _eof_trans
		next;
	end
	  case _hotcell_lexer_eof_actions[cs]
	when 6 then
# line 46 "lib/hotcell/lexer.rl"
		begin
 raise_unterminated_string; 		end
# line 908 "lib/hotcell/lexerr.rb"
	  end
	end

	end
	if _goto_level <= _out
		break
	end
end
	end

# line 74 "lib/hotcell/lexerr.rl"
    #%

    raise_unexpected_symbol unless @ts.nil?

    if cs == hotcell_lexer_en_dstring
      @ts = @dstring_start
      raise_unterminated_string
    end

    @token_array
  end
end
