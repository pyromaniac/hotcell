module Hotcell
  class Command < Hotcell::Node
    class_attribute :_validations
    self._validations = {}

    def self.validate_arguments_count options
      arguments_count = case options
      when Hash
        Range.new(options[:min].to_i,
          options[:max].present? ? options[:max].to_i : Float::INFINITY)
      when Range
        options
      else
        options.to_i
      end

      self._validations = _validations.merge(arguments_count: arguments_count)
    end

    def validate_arguments_count!
      return unless _validations.key?(:arguments_count)

      args_count = children.count
      valid_args_count = _validations[:arguments_count]

      valid = valid_args_count.is_a?(Integer) ?
        args_count == valid_args_count : valid_args_count.include?(args_count)

      raise Hotcell::ArgumentError.new(
        "Wrond number of arguments for `#{name}` (#{args_count} for #{valid_args_count})",
        *position_info
      ) unless valid
    end

    def validate!
      validate_arguments_count!
    end

    def process context, *args
    end

    def render context
      context.safe do
        process(context, *render_children(context))
      end
    end
  end
end
