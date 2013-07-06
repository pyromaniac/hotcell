module Hotcell
  class Manipulator
    module Mixin
      extend ActiveSupport::Concern

      included do
        class_attribute :manipulator_methods, instance_writter: false
        self.manipulator_methods = Set.new

        def self.manipulate *methods
          self.manipulator_methods = Set.new(manipulator_methods.to_a + methods.flatten.map(&:to_s))
        end
      end

      def to_manipulator
        self
      end

      def manipulator_invoke method, *arguments
        if method == '[]'
          manipulator_invoke_brackets *arguments
        elsif manipulator_invokable? method
          send(method, *arguments)
        end
      end

    private

      def manipulator_invokable? method
        manipulator_methods.include? method
      end

      def manipulator_invoke_brackets *arguments
        if respond_to? :[]
          self[*arguments]
        else
          manipulator_invoke *arguments
        end
      end
    end

    include Mixin

    def manipulator_methods
      @manipulator_methods ||= Set.new((self.class.public_instance_methods -
        Hotcell::Manipulator.public_instance_methods).map(&:to_s))
    end
  end
end
