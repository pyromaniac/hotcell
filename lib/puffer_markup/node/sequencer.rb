module PufferMarkup
  class Sequencer < PufferMarkup::Node
    def process context, *values
      values.last
    end
  end
end
