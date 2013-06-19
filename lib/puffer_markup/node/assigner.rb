module PufferMarkup
  class Assigner < PufferMarkup::Node
    def initialize *attrs
      super :ASSIGN, *attrs
    end

    def process context, name, value
      context[name] = value
    end
  end
end
