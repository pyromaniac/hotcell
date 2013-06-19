%%{
  #%
  machine puffer_lexer;

  variable data @data;
  variable te @te;
  variable ts @ts;

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
  sstring = squote (snon_quote | escaped_symbol)* squote @lerr{ raise_unterminated_string };

  dquote = '"';
  dnon_quote = [^\\"];
  dstring = dquote (dnon_quote | escaped_symbol)* dquote @lerr{ raise_unterminated_string };

  rquote = '/';
  rnon_quote = [^\\/];
  regexp = rquote @{ regexp_ambiguity { fgoto expression; } }
    (rnon_quote | escaped_symbol)* rquote alpha* @lerr{ raise_unterminated_regexp };


  numeric = digit* ('.' digit+)?;
  identifer = (alpha | '_') (alnum | '_')* [?!]?;
  operator = arithmetic | logic | flow | structure;
  comment = '#' ([^\n}]+ | '}' [^}])*;
  blank = [\t\v\f\r ];

  tag_open = '{{' [!\#]?;
  tag_close = '}}';
  template = [^{]+ | '{';

  template_comment_close = '#}}';
  template_comment_body = [^\#]+ | '#';


  expression := |*
    tag_close => { emit_tag; fret; };
    operator => { emit_operator };
    numeric => { emit_numeric };
    identifer => { emit_identifer };
    sstring => { emit_sstring };
    dstring => { emit_dstring };
    regexp => { emit_regexp };
    comment => { emit_comment };
    blank;
  *|;

  template_comment := |*
    template_comment_close => { emit_comment; fret; };
    template_comment_body => { emit_comment };
  *|;

  main := |*
    tag_open => { emit_tag_or_comment ->{ fcall expression; }, ->{ fcall template_comment; } };
    template => { emit_template };
  *|;
}%%
#%

module PufferMarkup
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

      %% write data;
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
      raise PufferMarkup::Errors::UnexpectedSymbol.new *current_position
    end

    def raise_unterminated_string
      raise PufferMarkup::Errors::UnterminatedString.new *current_position
    end

    def raise_unterminated_regexp
      raise PufferMarkup::Errors::UnterminatedRegexp.new *current_position
    end

    def tokens
      @tokens ||= tokenize
    end

    def tokenize
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
end
