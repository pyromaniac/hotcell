module Hotcell
  class Summoner < Hotcell::Node
    def initialize *attrs
      super :METHOD, *attrs
    end

    def process context, object, method, *arguments
      (object.to_manipulator || context).manipulator_invoke(method, *arguments)
    end
  end
end
