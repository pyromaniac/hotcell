module Hotcell
  module Commands
    class If < Hotcell::Block
      class Else < Hotcell::Command
      end

      class Elsif < Hotcell::Command
      end

      subcommands else: Else, elsif: Elsif

      def subcommand_error subcommand, *allowed_names
        raise Hotcell::BlockError.new(
          "Unexpected subcommand `#{subcommand.name}` for `#{name}` command",
          *subcommand.name.hotcell_position
        ) unless allowed_names.flatten.include?(subcommand.name)
      end

      def subcommand_argument_error subcommand, allowed_args_counts
        proper_args_count = allowed_args_counts[subcommand.name]
        args_count = subcommand.children.size

        raise Hotcell::ArgumentError.new(
          "Wrond number of arguments for `#{subcommand.name}` (#{args_count} for #{proper_args_count})",
          *subcommand.name.hotcell_position
        ) if args_count != proper_args_count
      end

      def validate!
        raise Hotcell::ArgumentError.new(
          "Wrond number of arguments for `#{name}` (#{children.count} for 1)", *name.hotcell_position
        ) if children.count != 1

        last = subcommands.length - 1
        subcommands.each_with_index do |subcommand, index|
          subcommand_error subcommand, (index == last ? ['elsif', 'else'] : ['elsif'])
          subcommand_argument_error subcommand, { 'elsif' => 1, 'else' => 0 }
        end
      end

      def process context, condition
        conditions = [[condition]]
        subnodes.each do |subnode|
          if subnode.is_a?(Hotcell::Command)
            conditions.last[1] = '' if conditions.last[1] == nil
            conditions << (subnode.name == 'elsif' ? [subnode.render_children(context).first] : [true])
          else
            conditions.last[1] = subnode.render(context)
          end
        end
        condition = conditions.detect { |condition| !!condition[0] }
        condition ? condition[1] : nil
      end
    end
  end
end

Hotcell.register_command if: Hotcell::Commands::If
