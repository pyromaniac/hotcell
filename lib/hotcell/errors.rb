module Hotcell
  class Errors
    class ParseError < StandardError
      def initialize line, column
        @line, @column = line, column
      end
    end

    class UnexpectedSymbol < ParseError
      def message
        "Unexpected symbol at #{@line}:#{@column}"
      end
    end

    class UnterminatedString < ParseError
      def message
        "Unterminated string starting at #{@line}:#{@column}"
      end
    end

    # class UnterminatedRegexp < ParseError
    #   def message
    #     "Unterminated regexp starting at: line #{@line}, column #{@column}"
    #   end
    # end

    class SyntaxError < StandardError
      def initialize message, line = nil, column = nil
        @message, @line, @column = message, line, column
      end

      def message
        "#{@message} at #{@line}:#{@column}"
      end
    end

    class BlockError < SyntaxError
    end

    class ArgumentError < SyntaxError
    end
  end
end
