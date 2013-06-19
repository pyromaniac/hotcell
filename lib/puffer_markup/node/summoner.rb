module PufferMarkup
  class Summoner < PufferMarkup::Node
    def initialize *attrs
      super :METHOD, *attrs
    end

    def process context, object, method, *arguments
      (object.to_hotcell || context).hotcell_invoke(method, *arguments)
    end
  end
end
