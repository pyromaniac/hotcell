module Hotcell
  class Joiner < Hotcell::Node
    def process context, *values
      values.join
    end
  end
end
