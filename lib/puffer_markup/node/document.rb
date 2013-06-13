module PufferMarkup
  class Document < PufferMarkup::Node
    def render context
      values(context).join
    end
  end
end
