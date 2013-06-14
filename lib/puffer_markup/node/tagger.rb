module PufferMarkup
  class Tagger < PufferMarkup::Node
    attr_reader :mode

    def initialize *_
      super
      @mode = options[:mode] || :normal
    end

    def process context, *values
      case mode
      when :normal
        values.last
      else
        nil
      end
    end

    def render context
      context.safe do
        process context, *values(context)
      end
    end
  end
end
