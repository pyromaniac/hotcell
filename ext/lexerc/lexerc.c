
#line 1 "ext/lexerc/lexerc.rl"

#line 12 "ext/lexerc/lexerc.rl"



#include <ruby.h>
#include <lexerc.h>

static VALUE mHotcell;
static VALUE cHotcellLexer;


#line 16 "ext/lexerc/lexerc.c"
static const int puffer_lexer_start = 12;
static const int puffer_lexer_first_final = 12;
static const int puffer_lexer_error = 0;

static const int puffer_lexer_en_expression = 16;
static const int puffer_lexer_en_template_comment = 26;
static const int puffer_lexer_en_main = 12;


#line 22 "ext/lexerc/lexerc.rl"

static char *p;
static char *ts;
static char *te;
static char *data;
static VALUE encoding;

static VALUE tokenize(VALUE self) {
  VALUE source = rb_iv_get(self, "@source");
  encoding = rb_funcall(source, rb_intern("encoding"), 0);
  VALUE string = rb_funcall(source, rb_intern("source"), 0);
  rb_iv_set(self, "@token_array", rb_ary_new());

  data = RSTRING_PTR(string);
  unsigned long length = RSTRING_LEN(string);

  int cs, top, act;
  int *stack = malloc(sizeof(int) * 300);

  p = data;
  char *pe = data + length;
  char *eof = pe;

  
#line 51 "ext/lexerc/lexerc.c"
	{
	cs = puffer_lexer_start;
	top = 0;
	ts = 0;
	te = 0;
	act = 0;
	}

#line 46 "ext/lexerc/lexerc.rl"
  
#line 62 "ext/lexerc/lexerc.c"
	{
	if ( p == pe )
		goto _test_eof;
	goto _resume;

_again:
	switch ( cs ) {
		case 12: goto st12;
		case 13: goto st13;
		case 14: goto st14;
		case 15: goto st15;
		case 16: goto st16;
		case 0: goto st0;
		case 17: goto st17;
		case 1: goto st1;
		case 2: goto st2;
		case 18: goto st18;
		case 3: goto st3;
		case 4: goto st4;
		case 5: goto st5;
		case 6: goto st6;
		case 19: goto st19;
		case 20: goto st20;
		case 7: goto st7;
		case 21: goto st21;
		case 22: goto st22;
		case 8: goto st8;
		case 23: goto st23;
		case 9: goto st9;
		case 24: goto st24;
		case 10: goto st10;
		case 25: goto st25;
		case 26: goto st26;
		case 27: goto st27;
		case 28: goto st28;
		case 11: goto st11;
	default: break;
	}

	if ( ++p == pe )
		goto _test_eof;
_resume:
	switch ( cs )
	{
tr20:
#line 92 "lib/hotcell/lexer.rl"
	{te = p;p--;{ emit_template; }}
	goto st12;
tr22:
#line 90 "lib/hotcell/lexer.rl"
	{te = p;p--;{ emit_tag; {stack[top++] = 12; goto st16;} }}
	goto st12;
tr23:
#line 90 "lib/hotcell/lexer.rl"
	{te = p+1;{ emit_tag; {stack[top++] = 12; goto st16;} }}
	goto st12;
tr24:
#line 91 "lib/hotcell/lexer.rl"
	{te = p+1;{ emit_comment; {stack[top++] = 12; goto st26;} }}
	goto st12;
st12:
#line 1 "NONE"
	{ts = 0;}
	if ( ++p == pe )
		goto _test_eof12;
case 12:
#line 1 "NONE"
	{ts = p;}
#line 131 "ext/lexerc/lexerc.c"
	if ( (*p) == 123 )
		goto st14;
	goto st13;
st13:
	if ( ++p == pe )
		goto _test_eof13;
case 13:
	if ( (*p) == 123 )
		goto tr20;
	goto st13;
st14:
	if ( ++p == pe )
		goto _test_eof14;
case 14:
	if ( (*p) == 123 )
		goto st15;
	goto tr20;
st15:
	if ( ++p == pe )
		goto _test_eof15;
case 15:
	switch( (*p) ) {
		case 33: goto tr23;
		case 35: goto tr24;
	}
	goto tr22;
tr1:
#line 78 "lib/hotcell/lexer.rl"
	{te = p+1;{ emit_dstring; }}
	goto st16;
tr3:
#line 80 "lib/hotcell/lexer.rl"
	{{p = ((te))-1;}{ emit_comment; }}
	goto st16;
tr5:
#line 74 "lib/hotcell/lexer.rl"
	{te = p+1;{ emit_operator; }}
	goto st16;
tr8:
#line 77 "lib/hotcell/lexer.rl"
	{te = p+1;{ emit_sstring; }}
	goto st16;
tr10:
#line 1 "NONE"
	{	switch( act ) {
	case 2:
	{{p = ((te))-1;} emit_operator; }
	break;
	case 3:
	{{p = ((te))-1;} emit_numeric; }
	break;
	}
	}
	goto st16;
tr12:
#line 74 "lib/hotcell/lexer.rl"
	{{p = ((te))-1;}{ emit_operator; }}
	goto st16;
tr25:
#line 81 "lib/hotcell/lexer.rl"
	{te = p+1;}
	goto st16;
tr36:
#line 74 "lib/hotcell/lexer.rl"
	{te = p;p--;{ emit_operator; }}
	goto st16;
tr37:
#line 80 "lib/hotcell/lexer.rl"
	{te = p;p--;{ emit_comment; }}
	goto st16;
tr40:
#line 79 "lib/hotcell/lexer.rl"
	{te = p;p--;{ emit_regexp; }}
	goto st16;
tr41:
#line 76 "lib/hotcell/lexer.rl"
	{te = p;p--;{ emit_identifer; }}
	goto st16;
tr42:
#line 76 "lib/hotcell/lexer.rl"
	{te = p+1;{ emit_identifer; }}
	goto st16;
tr43:
#line 73 "lib/hotcell/lexer.rl"
	{te = p+1;{ emit_tag; {cs = stack[--top];goto _again;} }}
	goto st16;
st16:
#line 1 "NONE"
	{ts = 0;}
	if ( ++p == pe )
		goto _test_eof16;
case 16:
#line 1 "NONE"
	{ts = p;}
#line 226 "ext/lexerc/lexerc.c"
	switch( (*p) ) {
		case 10: goto tr5;
		case 32: goto tr25;
		case 33: goto st17;
		case 34: goto st1;
		case 35: goto tr4;
		case 38: goto st4;
		case 39: goto st5;
		case 42: goto st19;
		case 45: goto tr29;
		case 46: goto tr30;
		case 47: goto tr31;
		case 63: goto tr5;
		case 91: goto tr5;
		case 93: goto tr5;
		case 95: goto st24;
		case 123: goto tr5;
		case 124: goto st10;
		case 125: goto st25;
	}
	if ( (*p) < 58 ) {
		if ( (*p) < 37 ) {
			if ( 9 <= (*p) && (*p) <= 13 )
				goto tr25;
		} else if ( (*p) > 44 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr32;
		} else
			goto tr5;
	} else if ( (*p) > 59 ) {
		if ( (*p) < 65 ) {
			if ( 60 <= (*p) && (*p) <= 62 )
				goto st17;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st24;
		} else
			goto st24;
	} else
		goto tr5;
	goto st0;
st0:
cs = 0;
	goto _out;
st17:
	if ( ++p == pe )
		goto _test_eof17;
case 17:
	if ( (*p) == 61 )
		goto tr5;
	goto tr36;
st1:
	if ( ++p == pe )
		goto _test_eof1;
case 1:
	switch( (*p) ) {
		case 34: goto tr1;
		case 92: goto st2;
	}
	goto st1;
st2:
	if ( ++p == pe )
		goto _test_eof2;
case 2:
	goto st1;
tr4:
#line 1 "NONE"
	{te = p+1;}
	goto st18;
st18:
	if ( ++p == pe )
		goto _test_eof18;
case 18:
#line 300 "ext/lexerc/lexerc.c"
	switch( (*p) ) {
		case 10: goto tr37;
		case 125: goto st3;
	}
	goto tr4;
st3:
	if ( ++p == pe )
		goto _test_eof3;
case 3:
	if ( (*p) == 125 )
		goto tr3;
	goto tr4;
st4:
	if ( ++p == pe )
		goto _test_eof4;
case 4:
	if ( (*p) == 38 )
		goto tr5;
	goto st0;
st5:
	if ( ++p == pe )
		goto _test_eof5;
case 5:
	switch( (*p) ) {
		case 39: goto tr8;
		case 92: goto st6;
	}
	goto st5;
st6:
	if ( ++p == pe )
		goto _test_eof6;
case 6:
	goto st5;
st19:
	if ( ++p == pe )
		goto _test_eof19;
case 19:
	if ( (*p) == 42 )
		goto tr5;
	goto tr36;
tr32:
#line 1 "NONE"
	{te = p+1;}
#line 75 "lib/hotcell/lexer.rl"
	{act = 3;}
	goto st20;
tr29:
#line 1 "NONE"
	{te = p+1;}
#line 74 "lib/hotcell/lexer.rl"
	{act = 2;}
	goto st20;
st20:
	if ( ++p == pe )
		goto _test_eof20;
case 20:
#line 357 "ext/lexerc/lexerc.c"
	if ( (*p) == 46 )
		goto st7;
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr32;
	goto tr10;
st7:
	if ( ++p == pe )
		goto _test_eof7;
case 7:
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr11;
	goto tr10;
tr11:
#line 1 "NONE"
	{te = p+1;}
#line 75 "lib/hotcell/lexer.rl"
	{act = 3;}
	goto st21;
tr30:
#line 1 "NONE"
	{te = p+1;}
#line 74 "lib/hotcell/lexer.rl"
	{act = 2;}
	goto st21;
st21:
	if ( ++p == pe )
		goto _test_eof21;
case 21:
#line 386 "ext/lexerc/lexerc.c"
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr11;
	goto tr10;
tr31:
#line 1 "NONE"
	{te = p+1;}
#line 4 "ext/lexerc/lexerc.rl"
	{
    if (regexp_possible == Qfalse) {
      emit_operator;
      {goto st16;}
    }
  }
	goto st22;
st22:
	if ( ++p == pe )
		goto _test_eof22;
case 22:
#line 405 "ext/lexerc/lexerc.c"
	switch( (*p) ) {
		case 47: goto st23;
		case 92: goto st9;
	}
	goto st8;
st8:
	if ( ++p == pe )
		goto _test_eof8;
case 8:
	switch( (*p) ) {
		case 47: goto st23;
		case 92: goto st9;
	}
	goto st8;
st23:
	if ( ++p == pe )
		goto _test_eof23;
case 23:
	if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto st23;
	} else if ( (*p) >= 65 )
		goto st23;
	goto tr40;
st9:
	if ( ++p == pe )
		goto _test_eof9;
case 9:
	goto st8;
st24:
	if ( ++p == pe )
		goto _test_eof24;
case 24:
	switch( (*p) ) {
		case 33: goto tr42;
		case 63: goto tr42;
		case 95: goto st24;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto st24;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto st24;
	} else
		goto st24;
	goto tr41;
st10:
	if ( ++p == pe )
		goto _test_eof10;
case 10:
	if ( (*p) == 124 )
		goto tr5;
	goto st0;
st25:
	if ( ++p == pe )
		goto _test_eof25;
case 25:
	if ( (*p) == 125 )
		goto tr43;
	goto tr36;
tr16:
#line 86 "lib/hotcell/lexer.rl"
	{{p = ((te))-1;}{ emit_comment; }}
	goto st26;
tr17:
#line 85 "lib/hotcell/lexer.rl"
	{te = p+1;{ emit_comment; {cs = stack[--top];goto _again;} }}
	goto st26;
tr46:
#line 86 "lib/hotcell/lexer.rl"
	{te = p;p--;{ emit_comment; }}
	goto st26;
st26:
#line 1 "NONE"
	{ts = 0;}
	if ( ++p == pe )
		goto _test_eof26;
case 26:
#line 1 "NONE"
	{ts = p;}
#line 487 "ext/lexerc/lexerc.c"
	if ( (*p) == 35 )
		goto tr45;
	goto st27;
st27:
	if ( ++p == pe )
		goto _test_eof27;
case 27:
	if ( (*p) == 35 )
		goto tr46;
	goto st27;
tr45:
#line 1 "NONE"
	{te = p+1;}
	goto st28;
st28:
	if ( ++p == pe )
		goto _test_eof28;
case 28:
#line 506 "ext/lexerc/lexerc.c"
	if ( (*p) == 125 )
		goto st11;
	goto tr46;
st11:
	if ( ++p == pe )
		goto _test_eof11;
case 11:
	if ( (*p) == 125 )
		goto tr17;
	goto tr16;
	}
	_test_eof12: cs = 12; goto _test_eof; 
	_test_eof13: cs = 13; goto _test_eof; 
	_test_eof14: cs = 14; goto _test_eof; 
	_test_eof15: cs = 15; goto _test_eof; 
	_test_eof16: cs = 16; goto _test_eof; 
	_test_eof17: cs = 17; goto _test_eof; 
	_test_eof1: cs = 1; goto _test_eof; 
	_test_eof2: cs = 2; goto _test_eof; 
	_test_eof18: cs = 18; goto _test_eof; 
	_test_eof3: cs = 3; goto _test_eof; 
	_test_eof4: cs = 4; goto _test_eof; 
	_test_eof5: cs = 5; goto _test_eof; 
	_test_eof6: cs = 6; goto _test_eof; 
	_test_eof19: cs = 19; goto _test_eof; 
	_test_eof20: cs = 20; goto _test_eof; 
	_test_eof7: cs = 7; goto _test_eof; 
	_test_eof21: cs = 21; goto _test_eof; 
	_test_eof22: cs = 22; goto _test_eof; 
	_test_eof8: cs = 8; goto _test_eof; 
	_test_eof23: cs = 23; goto _test_eof; 
	_test_eof9: cs = 9; goto _test_eof; 
	_test_eof24: cs = 24; goto _test_eof; 
	_test_eof10: cs = 10; goto _test_eof; 
	_test_eof25: cs = 25; goto _test_eof; 
	_test_eof26: cs = 26; goto _test_eof; 
	_test_eof27: cs = 27; goto _test_eof; 
	_test_eof28: cs = 28; goto _test_eof; 
	_test_eof11: cs = 11; goto _test_eof; 

	_test_eof: {}
	if ( p == eof )
	{
	switch ( cs ) {
	case 13: goto tr20;
	case 14: goto tr20;
	case 15: goto tr22;
	case 17: goto tr36;
	case 18: goto tr37;
	case 3: goto tr3;
	case 19: goto tr36;
	case 20: goto tr10;
	case 7: goto tr10;
	case 21: goto tr10;
	case 22: goto tr36;
	case 8: goto tr12;
	case 23: goto tr40;
	case 9: goto tr12;
	case 24: goto tr41;
	case 25: goto tr36;
	case 27: goto tr46;
	case 28: goto tr46;
	case 11: goto tr16;
	case 5: 
#line 45 "lib/hotcell/lexer.rl"
	{ raise_unterminated_string; }
	break;
	case 1: 
#line 49 "lib/hotcell/lexer.rl"
	{ raise_unterminated_string; }
	break;
#line 578 "ext/lexerc/lexerc.c"
	}
	}

	_out: {}
	}

#line 47 "ext/lexerc/lexerc.rl"

  free(stack);

  if (ts > 0 && ((ts - data) < (pe - data - 1))) {
    raise_unexpected_symbol;
  }

  return rb_iv_get(self, "@token_array");
}

static VALUE current_position(VALUE self) {
  return INT2FIX(ts - data);
}

static VALUE current_value(VALUE self) {
  VALUE string = rb_str_new(ts, te - ts);
  return rb_funcall(string, rb_intern("force_encoding"), 1, encoding);
}

static VALUE current_error(VALUE self) {
  VALUE parsed = rb_str_new(ts, p - ts == 0 ? 1 : p - ts);
  VALUE encoded = rb_funcall(parsed, rb_intern("force_encoding"), 1, encoding);

  VALUE source = rb_iv_get(self, "@source");
  VALUE info = rb_funcall(source, rb_intern("info"), 1, INT2FIX(ts - data));
  VALUE line = rb_funcall(info, rb_intern("[]"), 1, ID2SYM(rb_intern("line")));
  VALUE column = rb_funcall(info, rb_intern("[]"), 1, ID2SYM(rb_intern("column")));

  return rb_ary_new3(3, encoded, line, column);
}

void Init_lexerc() {
  mHotcell = rb_const_get(rb_cObject, rb_intern("Hotcell"));
  cHotcellLexer = rb_const_get(mHotcell, rb_intern("Lexer"));

  rb_define_method(cHotcellLexer, "tokenize", tokenize, 0);
  rb_define_method(cHotcellLexer, "current_position", current_position, 0);
  rb_define_method(cHotcellLexer, "current_value", current_value, 0);
  rb_define_method(cHotcellLexer, "current_error", current_error, 0);
}
