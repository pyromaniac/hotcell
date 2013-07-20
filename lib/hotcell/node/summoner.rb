module Hotcell
  class Summoner < Hotcell::Node
    def process context, target = nil, *arguments
      (target ? target.to_tong : context).tong_invoke(name, *arguments)
    end
  end
end
