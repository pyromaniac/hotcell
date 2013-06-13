module PufferMarkup
  class Assigner < PufferMarkup::Node
    def render context
      values = values(context)
      context[values.first] = values.second
    end
  end
end
