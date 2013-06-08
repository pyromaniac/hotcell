module PufferMarkup
  class Errors
    class ParseError < StandardError
      def initialize line, column
        @line, @column = line, column
      end
    end

    class UnexpectedSymbol < ParseError
      def message
        "Unexpected symbol at: line #{@line}, column #{@column}"
      end
    end

    class UnterminatedString < ParseError
      def message
        "Unterminated string starting at: line #{@line}, column #{@column}"
      end
    end

    # class UnterminatedRegexp < ParseError
    #   def message
    #     "Unterminated regexp starting at: line #{@line}, column #{@column}"
    #   end
    # end
  end
end
