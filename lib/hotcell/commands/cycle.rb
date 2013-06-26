module Hotcell
  module Commands
    class Cycle < Hotcell::Command
      def process context, *arguments
        targets, group = normalize_arguments arguments

        context.shared[:cycle] ||= {}
        index = context.shared[:cycle][group] || 0

        result = targets[index]
        index += 1
        index = 0 if index >= targets.size

        context.shared[:cycle][group] = index
        result
      end

      def normalize_arguments arguments
        if arguments.count == 1
          if arguments.first.is_a? Hash
            [Array.wrap(arguments.first.values.first), arguments.first.keys.first]
          else
            [Array.wrap(arguments.first), default_group]
          end
        else
          options = arguments.extract_options!
          [arguments, options['group'].to_s.presence || default_group]
        end
      end

      def default_group
        @default_group ||= object_id.to_s
      end
    end
  end
end

Hotcell.register_command cycle: Hotcell::Commands::Cycle
