
#line 1 "ext/lexerc/lexerc.rl"

#line 39 "ext/lexerc/lexerc.rl"



#include <ruby.h>
#include <lexerc.h>

static VALUE mHotcell;
static VALUE cHotcellLexer;


#line 16 "ext/lexerc/lexerc.c"
static const int puffer_lexer_start = 19;
static const int puffer_lexer_first_final = 19;
static const int puffer_lexer_error = 0;

static const int puffer_lexer_en_dstring = 23;
static const int puffer_lexer_en_interpolation = 26;
static const int puffer_lexer_en_expression = 37;
static const int puffer_lexer_en_template_comment = 50;
static const int puffer_lexer_en_main = 19;


#line 49 "ext/lexerc/lexerc.rl"

static char *p;
static char *ts;
static char *te;
static char *data;
static VALUE encoding;
static int braces_count;
static long dstring_start;

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

  
#line 55 "ext/lexerc/lexerc.c"
	{
	cs = puffer_lexer_start;
	top = 0;
	ts = 0;
	te = 0;
	act = 0;
	}

#line 75 "ext/lexerc/lexerc.rl"
  
#line 66 "ext/lexerc/lexerc.c"
	{
	if ( p == pe )
		goto _test_eof;
	goto _resume;

_again:
	switch ( cs ) {
		case 19: goto st19;
		case 20: goto st20;
		case 21: goto st21;
		case 22: goto st22;
		case 1: goto st1;
		case 23: goto st23;
		case 24: goto st24;
		case 2: goto st2;
		case 25: goto st25;
		case 26: goto st26;
		case 0: goto st0;
		case 27: goto st27;
		case 28: goto st28;
		case 3: goto st3;
		case 4: goto st4;
		case 5: goto st5;
		case 29: goto st29;
		case 30: goto st30;
		case 6: goto st6;
		case 31: goto st31;
		case 32: goto st32;
		case 33: goto st33;
		case 34: goto st34;
		case 7: goto st7;
		case 35: goto st35;
		case 8: goto st8;
		case 36: goto st36;
		case 9: goto st9;
		case 37: goto st37;
		case 38: goto st38;
		case 39: goto st39;
		case 40: goto st40;
		case 10: goto st10;
		case 11: goto st11;
		case 12: goto st12;
		case 13: goto st13;
		case 41: goto st41;
		case 42: goto st42;
		case 14: goto st14;
		case 43: goto st43;
		case 44: goto st44;
		case 45: goto st45;
		case 46: goto st46;
		case 15: goto st15;
		case 47: goto st47;
		case 16: goto st16;
		case 48: goto st48;
		case 17: goto st17;
		case 49: goto st49;
		case 50: goto st50;
		case 51: goto st51;
		case 52: goto st52;
		case 18: goto st18;
	default: break;
	}

	if ( ++p == pe )
		goto _test_eof;
_resume:
	switch ( cs )
	{
tr0:
#line 110 "lib/hotcell/lexer.rl"
	{{p = ((te))-1;}{ emit_tag; {stack[top++] = 19; goto st37;} }}
	goto st19;
tr1:
#line 110 "lib/hotcell/lexer.rl"
	{te = p+1;{ emit_tag; {stack[top++] = 19; goto st37;} }}
	goto st19;
tr31:
#line 112 "lib/hotcell/lexer.rl"
	{te = p;p--;{ emit_template; }}
	goto st19;
tr33:
#line 110 "lib/hotcell/lexer.rl"
	{te = p;p--;{ emit_tag; {stack[top++] = 19; goto st37;} }}
	goto st19;
tr34:
#line 111 "lib/hotcell/lexer.rl"
	{te = p+1;{ emit_comment; {stack[top++] = 19; goto st50;} }}
	goto st19;
st19:
#line 1 "NONE"
	{ts = 0;}
	if ( ++p == pe )
		goto _test_eof19;
case 19:
#line 1 "NONE"
	{ts = p;}
#line 163 "ext/lexerc/lexerc.c"
	if ( (*p) == 123 )
		goto st21;
	goto st20;
st20:
	if ( ++p == pe )
		goto _test_eof20;
case 20:
	if ( (*p) == 123 )
		goto tr31;
	goto st20;
st21:
	if ( ++p == pe )
		goto _test_eof21;
case 21:
	if ( (*p) == 123 )
		goto tr32;
	goto tr31;
tr32:
#line 1 "NONE"
	{te = p+1;}
	goto st22;
st22:
	if ( ++p == pe )
		goto _test_eof22;
case 22:
#line 189 "ext/lexerc/lexerc.c"
	switch( (*p) ) {
		case 33: goto tr1;
		case 35: goto tr34;
		case 94: goto tr1;
		case 101: goto st1;
		case 114: goto st1;
		case 126: goto tr1;
	}
	goto tr33;
st1:
	if ( ++p == pe )
		goto _test_eof1;
case 1:
	if ( (*p) == 32 )
		goto tr1;
	goto tr0;
tr2:
#line 1 "NONE"
	{	switch( act ) {
	case 0:
	{{goto st0;}}
	break;
	case 3:
	{{p = ((te))-1;} emit_dstring; }
	break;
	}
	}
	goto st23;
tr36:
#line 73 "lib/hotcell/lexer.rl"
	{te = p+1;{ emit_dstring_close; {cs = stack[--top];goto _again;} }}
	goto st23;
tr39:
#line 75 "lib/hotcell/lexer.rl"
	{te = p;p--;{ emit_dstring; }}
	goto st23;
tr40:
#line 11 "ext/lexerc/lexerc.rl"
	{te = p+1;{
    braces_count = 0;
    emit_interpolation;
    {stack[top++] = 23; goto st26;}
  }}
	goto st23;
st23:
#line 1 "NONE"
	{ts = 0;}
#line 1 "NONE"
	{act = 0;}
	if ( ++p == pe )
		goto _test_eof23;
case 23:
#line 1 "NONE"
	{ts = p;}
#line 244 "ext/lexerc/lexerc.c"
	switch( (*p) ) {
		case 34: goto tr36;
		case 35: goto st25;
		case 92: goto st2;
	}
	goto tr3;
tr3:
#line 1 "NONE"
	{te = p+1;}
#line 75 "lib/hotcell/lexer.rl"
	{act = 3;}
	goto st24;
st24:
	if ( ++p == pe )
		goto _test_eof24;
case 24:
#line 261 "ext/lexerc/lexerc.c"
	if ( (*p) == 92 )
		goto st2;
	if ( 34 <= (*p) && (*p) <= 35 )
		goto tr39;
	goto tr3;
st2:
	if ( ++p == pe )
		goto _test_eof2;
case 2:
	goto tr3;
st25:
	if ( ++p == pe )
		goto _test_eof25;
case 25:
	if ( (*p) == 123 )
		goto tr40;
	goto tr39;
tr4:
#line 81 "lib/hotcell/lexer.rl"
	{te = p+1;{ emit_operator; }}
	goto st26;
tr7:
#line 87 "lib/hotcell/lexer.rl"
	{te = p+1;{ emit_string; }}
	goto st26;
tr9:
#line 1 "NONE"
	{	switch( act ) {
	case 4:
	{{p = ((te))-1;} emit_operator; }
	break;
	case 8:
	{{p = ((te))-1;} emit_numeric; }
	break;
	}
	}
	goto st26;
tr11:
#line 81 "lib/hotcell/lexer.rl"
	{{p = ((te))-1;}{ emit_operator; }}
	goto st26;
tr41:
#line 89 "lib/hotcell/lexer.rl"
	{te = p+1;}
	goto st26;
tr51:
#line 17 "ext/lexerc/lexerc.rl"
	{te = p+1;{
    emit_operator;
    braces_count++;
  }}
	goto st26;
tr53:
#line 22 "ext/lexerc/lexerc.rl"
	{te = p+1;{
    if (braces_count < 1) {
      emit_interpolation;
      {cs = stack[--top];goto _again;}
    } else {
      emit_operator;
      braces_count--;
    }
  }}
	goto st26;
tr54:
#line 81 "lib/hotcell/lexer.rl"
	{te = p;p--;{ emit_operator; }}
	goto st26;
tr55:
#line 32 "ext/lexerc/lexerc.rl"
	{te = p;p--;{
    dstring_start = ts - data;
    emit_dstring_open;
    {stack[top++] = 26; goto st23;}
  }}
	goto st26;
tr57:
#line 85 "lib/hotcell/lexer.rl"
	{te = p;p--;{ emit_numeric; }}
	goto st26;
tr59:
#line 88 "lib/hotcell/lexer.rl"
	{te = p;p--;{ emit_regexp; }}
	goto st26;
tr60:
#line 86 "lib/hotcell/lexer.rl"
	{te = p;p--;{ emit_identifer; }}
	goto st26;
tr61:
#line 86 "lib/hotcell/lexer.rl"
	{te = p+1;{ emit_identifer; }}
	goto st26;
st26:
#line 1 "NONE"
	{ts = 0;}
	if ( ++p == pe )
		goto _test_eof26;
case 26:
#line 1 "NONE"
	{ts = p;}
#line 362 "ext/lexerc/lexerc.c"
	switch( (*p) ) {
		case 10: goto tr4;
		case 32: goto tr41;
		case 33: goto st27;
		case 34: goto st28;
		case 38: goto st3;
		case 39: goto st4;
		case 42: goto st29;
		case 45: goto tr46;
		case 46: goto st32;
		case 47: goto tr48;
		case 63: goto tr4;
		case 91: goto tr4;
		case 93: goto tr4;
		case 95: goto st36;
		case 123: goto tr51;
		case 124: goto st9;
		case 125: goto tr53;
	}
	if ( (*p) < 58 ) {
		if ( (*p) < 37 ) {
			if ( 9 <= (*p) && (*p) <= 13 )
				goto tr41;
		} else if ( (*p) > 44 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr49;
		} else
			goto tr4;
	} else if ( (*p) > 59 ) {
		if ( (*p) < 65 ) {
			if ( 60 <= (*p) && (*p) <= 62 )
				goto st27;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st36;
		} else
			goto st36;
	} else
		goto tr4;
	goto st0;
st0:
cs = 0;
	goto _out;
st27:
	if ( ++p == pe )
		goto _test_eof27;
case 27:
	if ( (*p) == 61 )
		goto tr4;
	goto tr54;
st28:
	if ( ++p == pe )
		goto _test_eof28;
case 28:
	if ( (*p) == 34 )
		goto tr7;
	goto tr55;
st3:
	if ( ++p == pe )
		goto _test_eof3;
case 3:
	if ( (*p) == 38 )
		goto tr4;
	goto st0;
st4:
	if ( ++p == pe )
		goto _test_eof4;
case 4:
	switch( (*p) ) {
		case 39: goto tr7;
		case 92: goto st5;
	}
	goto st4;
st5:
	if ( ++p == pe )
		goto _test_eof5;
case 5:
	goto st4;
st29:
	if ( ++p == pe )
		goto _test_eof29;
case 29:
	if ( (*p) == 42 )
		goto tr4;
	goto tr54;
tr46:
#line 1 "NONE"
	{te = p+1;}
#line 81 "lib/hotcell/lexer.rl"
	{act = 4;}
	goto st30;
tr49:
#line 1 "NONE"
	{te = p+1;}
#line 85 "lib/hotcell/lexer.rl"
	{act = 8;}
	goto st30;
st30:
	if ( ++p == pe )
		goto _test_eof30;
case 30:
#line 464 "ext/lexerc/lexerc.c"
	if ( (*p) == 46 )
		goto st6;
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr49;
	goto tr9;
st6:
	if ( ++p == pe )
		goto _test_eof6;
case 6:
	if ( 48 <= (*p) && (*p) <= 57 )
		goto st31;
	goto tr9;
st31:
	if ( ++p == pe )
		goto _test_eof31;
case 31:
	if ( 48 <= (*p) && (*p) <= 57 )
		goto st31;
	goto tr57;
st32:
	if ( ++p == pe )
		goto _test_eof32;
case 32:
	if ( (*p) == 46 )
		goto st33;
	if ( 48 <= (*p) && (*p) <= 57 )
		goto st31;
	goto tr54;
st33:
	if ( ++p == pe )
		goto _test_eof33;
case 33:
	if ( (*p) == 46 )
		goto tr4;
	goto tr54;
tr48:
#line 1 "NONE"
	{te = p+1;}
#line 4 "ext/lexerc/lexerc.rl"
	{
    if (regexp_possible == Qfalse) {
      emit_operator;
      {goto st37;}
    }
  }
	goto st34;
st34:
	if ( ++p == pe )
		goto _test_eof34;
case 34:
#line 515 "ext/lexerc/lexerc.c"
	switch( (*p) ) {
		case 47: goto st35;
		case 92: goto st8;
	}
	goto st7;
st7:
	if ( ++p == pe )
		goto _test_eof7;
case 7:
	switch( (*p) ) {
		case 47: goto st35;
		case 92: goto st8;
	}
	goto st7;
st35:
	if ( ++p == pe )
		goto _test_eof35;
case 35:
	if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto st35;
	} else if ( (*p) >= 65 )
		goto st35;
	goto tr59;
st8:
	if ( ++p == pe )
		goto _test_eof8;
case 8:
	goto st7;
st36:
	if ( ++p == pe )
		goto _test_eof36;
case 36:
	switch( (*p) ) {
		case 33: goto tr61;
		case 63: goto tr61;
		case 95: goto st36;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto st36;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto st36;
	} else
		goto st36;
	goto tr60;
st9:
	if ( ++p == pe )
		goto _test_eof9;
case 9:
	if ( (*p) == 124 )
		goto tr4;
	goto st0;
tr15:
#line 100 "lib/hotcell/lexer.rl"
	{{p = ((te))-1;}{ emit_comment; }}
	goto st37;
tr17:
#line 95 "lib/hotcell/lexer.rl"
	{te = p+1;{ emit_operator; }}
	goto st37;
tr19:
#line 98 "lib/hotcell/lexer.rl"
	{te = p+1;{ emit_string; }}
	goto st37;
tr21:
#line 1 "NONE"
	{	switch( act ) {
	case 15:
	{{p = ((te))-1;} emit_operator; }
	break;
	case 16:
	{{p = ((te))-1;} emit_numeric; }
	break;
	}
	}
	goto st37;
tr23:
#line 95 "lib/hotcell/lexer.rl"
	{{p = ((te))-1;}{ emit_operator; }}
	goto st37;
tr62:
#line 101 "lib/hotcell/lexer.rl"
	{te = p+1;}
	goto st37;
tr74:
#line 95 "lib/hotcell/lexer.rl"
	{te = p;p--;{ emit_operator; }}
	goto st37;
tr75:
#line 32 "ext/lexerc/lexerc.rl"
	{te = p;p--;{
    dstring_start = ts - data;
    emit_dstring_open;
    {stack[top++] = 37; goto st23;}
  }}
	goto st37;
tr76:
#line 100 "lib/hotcell/lexer.rl"
	{te = p;p--;{ emit_comment; }}
	goto st37;
tr79:
#line 96 "lib/hotcell/lexer.rl"
	{te = p;p--;{ emit_numeric; }}
	goto st37;
tr81:
#line 99 "lib/hotcell/lexer.rl"
	{te = p;p--;{ emit_regexp; }}
	goto st37;
tr82:
#line 97 "lib/hotcell/lexer.rl"
	{te = p;p--;{ emit_identifer; }}
	goto st37;
tr83:
#line 97 "lib/hotcell/lexer.rl"
	{te = p+1;{ emit_identifer; }}
	goto st37;
tr84:
#line 93 "lib/hotcell/lexer.rl"
	{te = p+1;{ emit_tag; {cs = stack[--top];goto _again;} }}
	goto st37;
st37:
#line 1 "NONE"
	{ts = 0;}
	if ( ++p == pe )
		goto _test_eof37;
case 37:
#line 1 "NONE"
	{ts = p;}
#line 646 "ext/lexerc/lexerc.c"
	switch( (*p) ) {
		case 10: goto tr17;
		case 32: goto tr62;
		case 33: goto st38;
		case 34: goto st39;
		case 35: goto tr16;
		case 38: goto st11;
		case 39: goto st12;
		case 42: goto st41;
		case 45: goto tr67;
		case 46: goto st44;
		case 47: goto tr69;
		case 63: goto tr17;
		case 91: goto tr17;
		case 93: goto tr17;
		case 95: goto st48;
		case 123: goto tr17;
		case 124: goto st17;
		case 125: goto st49;
	}
	if ( (*p) < 58 ) {
		if ( (*p) < 37 ) {
			if ( 9 <= (*p) && (*p) <= 13 )
				goto tr62;
		} else if ( (*p) > 44 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr70;
		} else
			goto tr17;
	} else if ( (*p) > 59 ) {
		if ( (*p) < 65 ) {
			if ( 60 <= (*p) && (*p) <= 62 )
				goto st38;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st48;
		} else
			goto st48;
	} else
		goto tr17;
	goto st0;
st38:
	if ( ++p == pe )
		goto _test_eof38;
case 38:
	if ( (*p) == 61 )
		goto tr17;
	goto tr74;
st39:
	if ( ++p == pe )
		goto _test_eof39;
case 39:
	if ( (*p) == 34 )
		goto tr19;
	goto tr75;
tr16:
#line 1 "NONE"
	{te = p+1;}
	goto st40;
st40:
	if ( ++p == pe )
		goto _test_eof40;
case 40:
#line 710 "ext/lexerc/lexerc.c"
	switch( (*p) ) {
		case 10: goto tr76;
		case 125: goto st10;
	}
	goto tr16;
st10:
	if ( ++p == pe )
		goto _test_eof10;
case 10:
	if ( (*p) == 125 )
		goto tr15;
	goto tr16;
st11:
	if ( ++p == pe )
		goto _test_eof11;
case 11:
	if ( (*p) == 38 )
		goto tr17;
	goto st0;
st12:
	if ( ++p == pe )
		goto _test_eof12;
case 12:
	switch( (*p) ) {
		case 39: goto tr19;
		case 92: goto st13;
	}
	goto st12;
st13:
	if ( ++p == pe )
		goto _test_eof13;
case 13:
	goto st12;
st41:
	if ( ++p == pe )
		goto _test_eof41;
case 41:
	if ( (*p) == 42 )
		goto tr17;
	goto tr74;
tr67:
#line 1 "NONE"
	{te = p+1;}
#line 95 "lib/hotcell/lexer.rl"
	{act = 15;}
	goto st42;
tr70:
#line 1 "NONE"
	{te = p+1;}
#line 96 "lib/hotcell/lexer.rl"
	{act = 16;}
	goto st42;
st42:
	if ( ++p == pe )
		goto _test_eof42;
case 42:
#line 767 "ext/lexerc/lexerc.c"
	if ( (*p) == 46 )
		goto st14;
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr70;
	goto tr21;
st14:
	if ( ++p == pe )
		goto _test_eof14;
case 14:
	if ( 48 <= (*p) && (*p) <= 57 )
		goto st43;
	goto tr21;
st43:
	if ( ++p == pe )
		goto _test_eof43;
case 43:
	if ( 48 <= (*p) && (*p) <= 57 )
		goto st43;
	goto tr79;
st44:
	if ( ++p == pe )
		goto _test_eof44;
case 44:
	if ( (*p) == 46 )
		goto st45;
	if ( 48 <= (*p) && (*p) <= 57 )
		goto st43;
	goto tr74;
st45:
	if ( ++p == pe )
		goto _test_eof45;
case 45:
	if ( (*p) == 46 )
		goto tr17;
	goto tr74;
tr69:
#line 1 "NONE"
	{te = p+1;}
#line 4 "ext/lexerc/lexerc.rl"
	{
    if (regexp_possible == Qfalse) {
      emit_operator;
      {goto st37;}
    }
  }
	goto st46;
st46:
	if ( ++p == pe )
		goto _test_eof46;
case 46:
#line 818 "ext/lexerc/lexerc.c"
	switch( (*p) ) {
		case 47: goto st47;
		case 92: goto st16;
	}
	goto st15;
st15:
	if ( ++p == pe )
		goto _test_eof15;
case 15:
	switch( (*p) ) {
		case 47: goto st47;
		case 92: goto st16;
	}
	goto st15;
st47:
	if ( ++p == pe )
		goto _test_eof47;
case 47:
	if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto st47;
	} else if ( (*p) >= 65 )
		goto st47;
	goto tr81;
st16:
	if ( ++p == pe )
		goto _test_eof16;
case 16:
	goto st15;
st48:
	if ( ++p == pe )
		goto _test_eof48;
case 48:
	switch( (*p) ) {
		case 33: goto tr83;
		case 63: goto tr83;
		case 95: goto st48;
	}
	if ( (*p) < 65 ) {
		if ( 48 <= (*p) && (*p) <= 57 )
			goto st48;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto st48;
	} else
		goto st48;
	goto tr82;
st17:
	if ( ++p == pe )
		goto _test_eof17;
case 17:
	if ( (*p) == 124 )
		goto tr17;
	goto st0;
st49:
	if ( ++p == pe )
		goto _test_eof49;
case 49:
	if ( (*p) == 125 )
		goto tr84;
	goto tr74;
tr27:
#line 106 "lib/hotcell/lexer.rl"
	{{p = ((te))-1;}{ emit_comment; }}
	goto st50;
tr28:
#line 105 "lib/hotcell/lexer.rl"
	{te = p+1;{ emit_comment; {cs = stack[--top];goto _again;} }}
	goto st50;
tr87:
#line 106 "lib/hotcell/lexer.rl"
	{te = p;p--;{ emit_comment; }}
	goto st50;
st50:
#line 1 "NONE"
	{ts = 0;}
	if ( ++p == pe )
		goto _test_eof50;
case 50:
#line 1 "NONE"
	{ts = p;}
#line 900 "ext/lexerc/lexerc.c"
	if ( (*p) == 35 )
		goto tr86;
	goto st51;
st51:
	if ( ++p == pe )
		goto _test_eof51;
case 51:
	if ( (*p) == 35 )
		goto tr87;
	goto st51;
tr86:
#line 1 "NONE"
	{te = p+1;}
	goto st52;
st52:
	if ( ++p == pe )
		goto _test_eof52;
case 52:
#line 919 "ext/lexerc/lexerc.c"
	if ( (*p) == 125 )
		goto st18;
	goto tr87;
st18:
	if ( ++p == pe )
		goto _test_eof18;
case 18:
	if ( (*p) == 125 )
		goto tr28;
	goto tr27;
	}
	_test_eof19: cs = 19; goto _test_eof; 
	_test_eof20: cs = 20; goto _test_eof; 
	_test_eof21: cs = 21; goto _test_eof; 
	_test_eof22: cs = 22; goto _test_eof; 
	_test_eof1: cs = 1; goto _test_eof; 
	_test_eof23: cs = 23; goto _test_eof; 
	_test_eof24: cs = 24; goto _test_eof; 
	_test_eof2: cs = 2; goto _test_eof; 
	_test_eof25: cs = 25; goto _test_eof; 
	_test_eof26: cs = 26; goto _test_eof; 
	_test_eof27: cs = 27; goto _test_eof; 
	_test_eof28: cs = 28; goto _test_eof; 
	_test_eof3: cs = 3; goto _test_eof; 
	_test_eof4: cs = 4; goto _test_eof; 
	_test_eof5: cs = 5; goto _test_eof; 
	_test_eof29: cs = 29; goto _test_eof; 
	_test_eof30: cs = 30; goto _test_eof; 
	_test_eof6: cs = 6; goto _test_eof; 
	_test_eof31: cs = 31; goto _test_eof; 
	_test_eof32: cs = 32; goto _test_eof; 
	_test_eof33: cs = 33; goto _test_eof; 
	_test_eof34: cs = 34; goto _test_eof; 
	_test_eof7: cs = 7; goto _test_eof; 
	_test_eof35: cs = 35; goto _test_eof; 
	_test_eof8: cs = 8; goto _test_eof; 
	_test_eof36: cs = 36; goto _test_eof; 
	_test_eof9: cs = 9; goto _test_eof; 
	_test_eof37: cs = 37; goto _test_eof; 
	_test_eof38: cs = 38; goto _test_eof; 
	_test_eof39: cs = 39; goto _test_eof; 
	_test_eof40: cs = 40; goto _test_eof; 
	_test_eof10: cs = 10; goto _test_eof; 
	_test_eof11: cs = 11; goto _test_eof; 
	_test_eof12: cs = 12; goto _test_eof; 
	_test_eof13: cs = 13; goto _test_eof; 
	_test_eof41: cs = 41; goto _test_eof; 
	_test_eof42: cs = 42; goto _test_eof; 
	_test_eof14: cs = 14; goto _test_eof; 
	_test_eof43: cs = 43; goto _test_eof; 
	_test_eof44: cs = 44; goto _test_eof; 
	_test_eof45: cs = 45; goto _test_eof; 
	_test_eof46: cs = 46; goto _test_eof; 
	_test_eof15: cs = 15; goto _test_eof; 
	_test_eof47: cs = 47; goto _test_eof; 
	_test_eof16: cs = 16; goto _test_eof; 
	_test_eof48: cs = 48; goto _test_eof; 
	_test_eof17: cs = 17; goto _test_eof; 
	_test_eof49: cs = 49; goto _test_eof; 
	_test_eof50: cs = 50; goto _test_eof; 
	_test_eof51: cs = 51; goto _test_eof; 
	_test_eof52: cs = 52; goto _test_eof; 
	_test_eof18: cs = 18; goto _test_eof; 

	_test_eof: {}
	if ( p == eof )
	{
	switch ( cs ) {
	case 20: goto tr31;
	case 21: goto tr31;
	case 22: goto tr33;
	case 1: goto tr0;
	case 24: goto tr39;
	case 2: goto tr2;
	case 25: goto tr39;
	case 27: goto tr54;
	case 28: goto tr55;
	case 29: goto tr54;
	case 30: goto tr9;
	case 6: goto tr9;
	case 31: goto tr57;
	case 32: goto tr54;
	case 33: goto tr54;
	case 34: goto tr54;
	case 7: goto tr11;
	case 35: goto tr59;
	case 8: goto tr11;
	case 36: goto tr60;
	case 38: goto tr74;
	case 39: goto tr75;
	case 40: goto tr76;
	case 10: goto tr15;
	case 41: goto tr74;
	case 42: goto tr21;
	case 14: goto tr21;
	case 43: goto tr79;
	case 44: goto tr74;
	case 45: goto tr74;
	case 46: goto tr74;
	case 15: goto tr23;
	case 47: goto tr81;
	case 16: goto tr23;
	case 48: goto tr82;
	case 49: goto tr74;
	case 51: goto tr87;
	case 52: goto tr87;
	case 18: goto tr27;
	case 4: 
	case 12: 
#line 46 "lib/hotcell/lexer.rl"
	{ raise_unterminated_string; }
	break;
#line 1032 "ext/lexerc/lexerc.c"
	}
	}

	_out: {}
	}

#line 76 "ext/lexerc/lexerc.rl"

  free(stack);

  if (ts > 0 && ((ts - data) < (pe - data - 1))) {
    raise_unexpected_symbol;
  }

  if (cs == puffer_lexer_en_dstring) {
    ts = data + dstring_start;
    raise_unterminated_string;
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
