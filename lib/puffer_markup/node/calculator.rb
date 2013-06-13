module PufferMarkup
  class Calculator < PufferMarkup::Node
    HANDLERS = {
      :PLUS => ->(value1, value2) { value1 + value2 },
      :MINUS => ->(value1, value2) { value1 - value2 },
      :UMINUS => ->(value) { -value },
      :UPLUS => ->(value) { value },
      :MULTIPLY => ->(value1, value2) { value1 * value2 },
      :POWER => ->(value1, value2) { value1 ** value2 },
      :DIVIDE => ->(value1, value2) { value1 / value2 },
      :MODULO => ->(value1, value2) { value1 % value2 },
      :AND => ->(value1, value2) { value1 && value2 },
      :OR => ->(value1, value2) { value1 || value2 },
      :NOT => ->(value) { !value },
      :EQUAL => ->(value1, value2) { value1 == value2 },
      :INEQUAL => ->(value1, value2) { value1 != value2 },
      :GT => ->(value1, value2) { value1 > value2 },
      :GTE => ->(value1, value2) { value1 >= value2 },
      :LT => ->(value1, value2) { value1 < value2 },
      :LTE => ->(value1, value2) { value1 <= value2 }
    }

    def optimize
      handler = HANDLERS[name]
      reducible = handler && children.none? { |child| child.is_a? PufferMarkup::Node }
      reducible ? handler.call(*children) : super
    end

    def render context
      handler = HANDLERS[name]
      raise "Could not find handler for `#{name}`" unless handler
      handler.call *values(context)
    end
  end
end
