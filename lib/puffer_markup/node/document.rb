module PufferMarkup
  class Document < PufferMarkup::Node
    def process context, *values
      values.join
    end
  end
end
