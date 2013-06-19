module PufferMarkup
  class Joiner < PufferMarkup::Node
    def process context, *values
      values.join
    end
  end
end
