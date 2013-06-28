module Hotcell
  module Commands
    class For < Hotcell::Block
      validate_arguments_count 2

      def validate!
        super

        raise Hotcell::SyntaxError.new(
          "Expected IDENTIFER as first argument in `#{name}` command", *position_info
        ) unless children[0].is_a?(Hotcell::Summoner)

        children[0] = children[0].name
      end

      def process context, variable, options
        forloop = options['loop'] == true ? 'loop' : options['loop']
        items = Array.wrap(options['in'])
        length = items.size

        items.map.with_index do |item, index|
          scope = { variable => item }
          scope.merge!(forloop => Forloop.new(items, index)) if forloop

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

        def size
          @size ||= @object.size
        end
        alias_method :length, :size
        alias_method :count, :size

        def rindex
          @rindex ||= size - index - 1
        end

        def first
          @first ||= index == 0
        end
        alias_method :first?, :first

        def last
          @last ||= index == size - 1
        end
        alias_method :last?, :last
      end
    end
  end
end

Hotcell.register_command for: Hotcell::Commands::For
