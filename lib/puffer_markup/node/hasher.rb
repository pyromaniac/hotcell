module PufferMarkup
  class Hasher < PufferMarkup::Node
    def render context
      Hash[values(context)]
    end
  end
end
