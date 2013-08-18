%%{
  machine hotcell_lexer;

  plus = '+';
  minus = '-';
  multiply = '*';
  power = '**';
  divide = '/';
  modulo = '%';
  arithmetic = plus | minus | multiply | power | divide | modulo;

  and = '&&';
  or = '||';
  not = '!';
  equal = '==';
  inequal = '!=';
  gt = '>';
  gte = '>=';
  lt = '<';
  lte = '<=';
  logic = and | or | not | equal | inequal | gt | gte | lt | lte;

  assign = '=';
  comma = ',';
  period = '.';
  range = '..' '.'?;
  colon = ':';
  question = '?';
  semicolon = ';';
  newline = '\n';
  flow = assign | comma | period | range | colon | question | semicolon | newline;

  array_open = '[';
  array_close = ']';
  hash_open = '{';
  hash_close = '}';
  bracket_open = '(';
  bracket_close = ')';
  structure = array_open | array_close | hash_open | hash_close | bracket_open | bracket_close;


  escaped_symbol = '\\' any;

  squote = "'";
  snon_quote = [^\\'];
  string_content = squote (snon_quote | escaped_symbol)* squote @lerr{ raise_unterminated_string; };
  string = '""' | string_content;

  rquote = '/';
  rnon_quote = [^\\/];
  regexp = rquote @RegexpCheck
    (rnon_quote | escaped_symbol)* rquote alpha* @lerr{ raise_unterminated_regexp; };


  numeric = '-'? digit* ('.' digit+)?;
  identifer = (alpha | '_') (alnum | '_')* [?!]?;
  operator = arithmetic | logic | flow | structure;
  comment = '#' ([^\n}]+ | '}' [^}])*;
  blank = [\t\v\f\r ];

  tag_open = '{{' ([!~^] | [re] ' ')?;
  tag_close = '}}';
  template = [^{]+ | '{';

  template_comment_open = '{{#';
  template_comment_close = '#}}';
  template_comment_body = [^\#]+ | '#';

  dnon_quote = [^\\#"];
  dstring_content = (dnon_quote | escaped_symbol)+ | '#';

  dstring := |*
    '"' => { emit_dstring_close; fret; };
    '#{' => Interpolate;
    dstring_content => { emit_dstring; };
  *|;

  interpolation_operator = operator - [{}];

  interpolation := |*
    interpolation_operator => { emit_operator; };
    '{' => OpenBrace;
    '}' => CloseBrace;
    '"' => ParseDstring;
    numeric => { emit_numeric; };
    identifer => { emit_identifer; };
    string => { emit_string; };
    regexp => { emit_regexp; };
    blank;
  *|;

  expression := |*
    tag_close => { emit_tag; fret; };
    '"' => ParseDstring;
    operator => { emit_operator; };
    numeric => { emit_numeric; };
    identifer => { emit_identifer; };
    string => { emit_string; };
    regexp => { emit_regexp; };
    comment => { emit_comment; };
    blank;
  *|;

  template_comment := |*
    template_comment_close => { emit_comment; fret; };
    template_comment_body => { emit_comment; };
  *|;

  main := |*
    tag_open => { emit_tag; fcall expression; };
    template_comment_open => { emit_comment; fcall template_comment; };
    template => { emit_template; };
  *|;
}%%
