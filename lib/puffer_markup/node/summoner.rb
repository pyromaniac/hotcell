module PufferMarkup
  class Summoner < PufferMarkup::Node
    def process context, object, method, *arguments
      (object.to_hotcell || context).hotcell_invoke(method, *arguments)
    end
  end
end
