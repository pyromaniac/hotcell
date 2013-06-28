module Hotcell
  module Commands
    class If < Hotcell::Block
      class Else < Hotcell::Command
        validate_arguments_count 0
      end

      class Elsif < Hotcell::Command
        validate_arguments_count 1
      end

      subcommand else: Else, elsif: Elsif
      validate_arguments_count 1

      def subcommand_error subcommand, *allowed_names
        raise Hotcell::BlockError.new(
          "Unexpected `#{subcommand.name}` for `#{name}` command",
          *subcommand.position_info
        ) unless allowed_names.flatten.include?(subcommand.name)
      end

      def validate!
        last = subcommands.length - 1
        subcommands.each_with_index do |subcommand, index|
          subcommand_error subcommand, (index == last ? ['elsif', 'else'] : ['elsif'])
        end

        super
      end

      def process context, condition
        conditions = [[condition]]
        subnodes.each do |subnode|
          if subnode.is_a?(Hotcell::Command)
            conditions.last[1] = '' if conditions.last[1] == nil
            conditions << (subnode.name == 'elsif' ? [subnode] : [true])
          else
            conditions.last[1] = subnode
          end
        end
        condition = conditions.detect do |condition|
          condition[0].is_a?(Hotcell::Command) ?
            condition[0].render_children(context).first : condition[0]
        end
        condition ? condition[1].render(context) : nil
      end
    end
  end
end

Hotcell.register_command if: Hotcell::Commands::If
