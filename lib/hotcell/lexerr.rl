%%{
  #%
  machine puffer_lexer;

  variable data @data;
  variable te @te;
  variable ts @ts;
  variable p @p;

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
  colon = ':';
  question = '?';
  semicolon = ';';
  newline = '\n';
  flow = assign | comma | period | colon | question | semicolon | newline;

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
  sstring = squote (snon_quote | escaped_symbol)* squote @lerr{ raise_unterminated_string(); };

  dquote = '"';
  dnon_quote = [^\\"];
  dstring = dquote (dnon_quote | escaped_symbol)* dquote @lerr{ raise_unterminated_string(); };

  rquote = '/';
  rnon_quote = [^\\/];
  regexp = rquote @{ regexp_ambiguity { fgoto expression; } }
    (rnon_quote | escaped_symbol)* rquote alpha* @lerr{ raise_unterminated_regexp(); };


  numeric = '-'? digit* ('.' digit+)?;
  identifer = (alpha | '_') (alnum | '_')* [?!]?;
  operator = arithmetic | logic | flow | structure;
  comment = '#' ([^\n}]+ | '}' [^}])*;
  blank = [\t\v\f\r ];

  tag_open = '{{' '!'?;
  tag_close = '}}';
  template = [^{]+ | '{';

  template_comment_open = '{{#';
  template_comment_close = '#}}';
  template_comment_body = [^\#]+ | '#';


  expression := |*
    tag_close => { emit_tag(); fret; };
    operator => { emit_operator(); };
    numeric => { emit_numeric(); };
    identifer => { emit_identifer(); };
    sstring => { emit_sstring(); };
    dstring => { emit_dstring(); };
    regexp => { emit_regexp(); };
    comment => { emit_comment(); };
    blank;
  *|;

  template_comment := |*
    template_comment_close => { emit_comment(); fret; };
    template_comment_body => { emit_comment(); };
  *|;

  main := |*
    tag_open => { emit_tag(); fcall expression; };
    template_comment_open => { emit_comment(); fcall template_comment; };
    template => { emit_template(); };
  *|;
}%%
#%

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
    %% write data;
    #%

    @data = @source.data
    @token_array = []

    %% write init;
    #%

    eof = pe
    stack = []

    %% write exec;
    #%

    raise_unexpected_symbol unless @ts.nil?

    @token_array
  end
end
