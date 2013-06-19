module Hotcell
  class Sequencer < Hotcell::Node
    def process context, *values
      values.last
    end
  end
end
