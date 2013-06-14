module PufferMarkup
  class Hasher < PufferMarkup::Node
    def render context, *values
      Hash[values]
    end
  end
end
