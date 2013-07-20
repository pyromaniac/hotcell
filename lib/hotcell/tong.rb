module Hotcell
  class Tong
    module Mixin
      extend ActiveSupport::Concern

      included do
        class_attribute :tong_methods, instance_writter: false
        self.tong_methods = Set.new

        def self.manipulate *methods
          self.tong_methods = Set.new(tong_methods.to_a + methods.flatten.map(&:to_s))
        end
      end

      def to_tong
        self
      end

      def tong_invoke method, *arguments
        if method == '[]'
          tong_invoke_brackets *arguments
        elsif tong_invokable? method
          send(method, *arguments)
        else
          tong_missing(method, *arguments)
        end
      end

      def tong_missing method, *arguments
      end

    private

      def tong_invokable? method
        tong_methods.include? method
      end

      def tong_invoke_brackets *arguments
        if respond_to? :[]
          self[*arguments]
        else
          tong_invoke *arguments
        end
      end
    end

    include Mixin

    def tong_methods
      @tong_methods ||= Set.new((self.class.public_instance_methods -
        Hotcell::Tong.public_instance_methods).map(&:to_s))
    end
  end
end
