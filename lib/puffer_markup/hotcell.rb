module PufferMarkup
  class Hotcell
    module Mixin
      extend ActiveSupport::Concern

      included do
        class_attribute :hotcell_methods, instance_writter: false
        self.hotcell_methods = Set.new

        def self.hotcell *methods
          self.hotcell_methods = Set.new(hotcell_methods.to_a + methods.flatten.map(&:to_s))
        end
      end

      def to_hotcell
        self
      end

      def hotcell_invoke method, *arguments
        send(method, *arguments) if hotcell_methods.include? method
      end
    end

    include Mixin

    def hotcell_methods
      @hotcell_methods ||= Set.new((self.class.public_instance_methods -
        PufferMarkup::Hotcell.public_instance_methods).map(&:to_s))
    end
  end
end
