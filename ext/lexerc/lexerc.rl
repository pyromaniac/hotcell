%%{
  machine puffer_lexer;

  action RegexpCheck {
    if (regexp_possible == Qfalse) {
      emit_operator;
      fgoto expression;
    }
  }

  include "lexer.rl";
}%%


#include <ruby.h>
#include <lexerc.h>

static VALUE mHotcell;
static VALUE cHotcellLexer;

%% write data;

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

  %% write init;
  %% write exec;

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
