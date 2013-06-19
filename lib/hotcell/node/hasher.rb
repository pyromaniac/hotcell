module Hotcell
  class Hasher < Hotcell::Node
    def render context, *values
      Hash[values]
    end
  end
end
