module PufferMarkup
  class Assigner < PufferMarkup::Node
    def process context, name, value
      context[name] = value
    end
  end
end
