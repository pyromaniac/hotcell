module Hotcell
  class ParseError < StandardError
    def initialize value, line, column
      @value, @line, @column = value, line, column
    end
  end

  class UnexpectedSymbol < ParseError
    def message
      "Unexpected symbol `#{@value}` at #{@line}:#{@column}"
    end
  end

  class UnterminatedString < ParseError
    def message
      "Unterminated string `#{@value}` starting at #{@line}:#{@column}"
    end
  end

  # class UnterminatedRegexp < ParseError
  #   def message
  #     "Unterminated regexp `#{@value}` starting at #{@line}:#{@column}"
  #   end
  # end

  class SyntaxError < StandardError
    def initialize value, line = nil, column = nil
      @value, @line, @column = value, line, column
    end

    def message
      "#{@value} at #{@line}:#{@column}"
    end
  end

  class UnexpectedLexem < ParseError
    def message
      "Unexpected #{@value} at #{@line}:#{@column}"
    end
  end

  class BlockError < SyntaxError
  end

  class ArgumentError < SyntaxError
  end
end
