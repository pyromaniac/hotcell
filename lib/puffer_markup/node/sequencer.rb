module PufferMarkup
  class Sequencer < PufferMarkup::Node
    def render context
      values(context).last
    end
  end
end
