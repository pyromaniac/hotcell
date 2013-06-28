module Hotcell
  class Error < StandardError
  end

  class ParseError < Error
    def initialize value, line, column
      @value, @line, @column = value, line, column
      super(compose_message)
    end
  end

  class UnexpectedSymbol < ParseError
    def compose_message
      "Unexpected symbol `#{@value}` at #{@line}:#{@column}"
    end
  end

  class UnterminatedString < ParseError
    def compose_message
      "Unterminated string `#{@value}` starting at #{@line}:#{@column}"
    end
  end

  # class UnterminatedRegexp < ParseError
  #   def compose_message
  #     "Unterminated regexp `#{@value}` starting at #{@line}:#{@column}"
  #   end
  # end

  class SyntaxError < Error
    def initialize value, line, column
      @value, @line, @column = value, line, column
      super(compose_message)
    end

    def compose_message
      "#{@value} at #{@line}:#{@column}"
    end
  end

  class UnexpectedLexem < ParseError
    def compose_message
      "Unexpected #{@value} at #{@line}:#{@column}"
    end
  end

  class BlockError < SyntaxError
  end

  class ArgumentError < SyntaxError
  end
end
