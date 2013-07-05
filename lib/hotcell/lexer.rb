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

    PREREGEXP = Set.new [
      :TOPEN, :NEWLINE, :SEMICOLON,
      :COLON, :COMMA, :PERIOD,
      :POPEN, :AOPEN, :HOPEN
    ]

    def initialize source
      @source = Source.wrap(source)
    end

    def emit symbol, value
      @token_array << [symbol, [value, current_position]]
    end

    def emit_operator
      value = current_value
      emit OPERATORS[value], value
    end

    def emit_numeric
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
      unless regexp_possible
        emit_operator
        yield
      end
    end

    def regexp_possible
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

    def emit_tag
      value = current_value
      emit (value == '}}' ? :TCLOSE : :TOPEN), value
    end

    def emit_comment
      last = @token_array[-1]
      if last && last[0] == :COMMENT
        last[1][0] += current_value
      else
        emit :COMMENT, current_value
      end
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

    def current_position
      raise NotImplementedError
    end

    def current_value
      raise NotImplementedError
    end

    def current_error
      raise NotImplementedError
    end

    def tokenize
      raise NotImplementedError
    end
  end
end
