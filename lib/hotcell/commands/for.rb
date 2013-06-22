module Hotcell
  module Commands
    class For < Hotcell::Block
      def validate!
        raise Hotcell::ArgumentError.new(
          "Wrond number of arguments for `#{name}` (#{children.count} for 2)", *name.hotcell_position
        ) if children.count != 2

        raise Hotcell::SyntaxError.new(
          "Expected IDENTIFER as first argument in `#{name}` command", *name.hotcell_position
        ) unless children[0].is_a?(Hotcell::Summoner)

        children[0] = children[0].name
      end

      def process context, variable, options
        forloop = options['loop'] == true ? 'loop' : options['loop']
        items = Array.wrap(options['in'])
        length = items.size

        items.map.with_index do |item, index|
          scope = { variable => item }
          scope.merge!(forloop => Forloop.new(item, index)) if forloop

          context.scoped scope do
            subnodes.first.try(:render, context)
          end
        end
      end

      class Forloop < Hotcell::Manipulator
        attr_reader :index

        def initialize object, index
          @object, @index = object, index
        end

        def prev
          @next ||= @object[index - 1] if index - 1 >= 0
        end

        def next
          @next ||= @object[index + 1]
        end

        def length
          @length ||= @object.size
        end
        alias_method :size, :length
        alias_method :count, :length

        def rindex
          @rindex ||= length - index - 1
        end

        def first
          @first ||= index == 0
        end
        alias_method :first?, :first

        def last
          @last ||= index == length - 1
        end
        alias_method :last?, :last
      end
    end
  end
end

Hotcell.register_command for: Hotcell::Commands::For
