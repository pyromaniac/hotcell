module Hotcell
  module Commands
    class Case < Hotcell::Block
      class When < Hotcell::Command
        validate_arguments_count min: 1
      end

      subcommand else: Hotcell::Commands::If::Else, when: When
      validate_arguments_count 1

      def subcommand_error subcommand, *allowed_names
        raise Hotcell::BlockError.new(
          "Unexpected `#{subcommand.name}` for `#{name}` command",
          *subcommand.position_info
        ) unless allowed_names.flatten.include?(subcommand.name)
      end

      def expected_when_error other = nil
        raise Hotcell::BlockError.new(
          "Expected `when` for `#{name}` command",
          *(other ? other.position_info : position_info)
        )
      end

      def validate!
        subcommand_error subcommands.first, 'when' if subcommands.count == 1

        last = subcommands.length - 1
        subcommands.each_with_index do |subcommand, index|
          subcommand_error subcommand, (index == last ? ['when', 'else'] : ['when'])
        end

        super

        expected_when_error subnodes.first unless subnodes.first.is_a?(Command) && subnodes.first.name == 'when'
      end

      def process context, value
        conditions = []
        subnodes.each do |subnode|
          if subnode.is_a?(Hotcell::Command)
            conditions.last[1] = '' if conditions.last && conditions.last[1] == nil
            conditions << (subnode.name == 'when' ? [subnode] : [true])
          else
            conditions.last[1] = subnode
          end
        end

        condition = conditions.detect do |condition|
          condition[0].is_a?(Hotcell::Command) ?
            condition[0].render_children(context).include?(value) : condition[0]
        end
        condition ? condition[1].render(context) : nil
      end
    end
  end
end

Hotcell.register_command case: Hotcell::Commands::Case
