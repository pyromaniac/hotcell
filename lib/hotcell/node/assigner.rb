module Hotcell
  class Assigner < Hotcell::Node
    def process context, value
      context[name] = value
    end
  end
end
