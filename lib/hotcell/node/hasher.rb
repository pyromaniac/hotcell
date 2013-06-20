module Hotcell
  class Hasher < Hotcell::Node
    def process context, *values
      Hash[values]
    end
  end
end
