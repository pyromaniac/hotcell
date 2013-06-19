module Hotcell
  class Assigner < Hotcell::Node
    def initialize *attrs
      super :ASSIGN, *attrs
    end

    def process context, name, value
      context[name] = value
    end
  end
end
