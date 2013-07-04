#define emit_tag rb_funcall(self, rb_intern("emit_tag"), 0)
#define emit_operator rb_funcall(self, rb_intern("emit_operator"), 0)
#define emit_numeric rb_funcall(self, rb_intern("emit_numeric"), 0)
#define emit_identifer rb_funcall(self, rb_intern("emit_identifer"), 0)
#define emit_sstring rb_funcall(self, rb_intern("emit_sstring"), 0)
#define emit_dstring rb_funcall(self, rb_intern("emit_dstring"), 0)
#define emit_regexp rb_funcall(self, rb_intern("emit_regexp"), 0)
#define emit_comment rb_funcall(self, rb_intern("emit_comment"), 0)
#define emit_template rb_funcall(self, rb_intern("emit_template"), 0)

#define raise_unterminated_string rb_funcall(self, rb_intern("raise_unterminated_string"), 0)
#define raise_unterminated_regexp rb_funcall(self, rb_intern("raise_unterminated_regexp"), 0)
#define raise_unexpected_symbol rb_funcall(self, rb_intern("raise_unexpected_symbol"), 0)

#define regexp_ambiguity(block) { \
    if (rb_funcall(self, rb_intern("regexp_possible?"), 0) == Qfalse) { \
      emit_operator; \
      block; \
    } \
  }
