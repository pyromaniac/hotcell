module Hotcell
  class Summoner < Hotcell::Node
    def process context, target = nil, *arguments
      (target.to_manipulator || context).manipulator_invoke(name, *arguments)
    end
  end
end
