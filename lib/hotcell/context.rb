require 'hotcell/scope'

module Hotcell
  class Context
    attr_reader :scope, :rescuer, :reraise
    delegate :[], :[]=, :key?, :scoped, to: :scope

    DEFAULT_RESCUER = ->(e){ "#{e.class}: #{e.message}" }

    def initialize options = {}
      options = options.dup

      scope = options.delete(:scope) || {}
      scope.merge! (options.delete(:variables) || {}).stringify_keys
      scope.merge! (options.delete(:environment) || {}).symbolize_keys

      @rescuer = options.delete(:rescuer) || DEFAULT_RESCUER
      @reraise = !!options.delete(:reraise)
      Array.wrap(options.delete(:helpers)).each do |helper|
        helpers_class.send(:include, helper)
      end

      @scope = Scope.new scope.merge!(options.stringify_keys)
    end

    def safe *default
      yield
    rescue => e
      rescue_result = rescuer.call(e)
      default.size > 0 ? default.first : rescue_result
    ensure
      raise e if e && reraise
    end

    def manipulator_invoke method, *arguments
      if arguments.any?
        helpers.manipulator_invoke(method, *arguments)
      else
        scope.key?(method) ? scope[method] : helpers.manipulator_invoke(method)
      end
    end

  private

    def helpers
      @helpers ||= helpers_class.new
    end

    def helpers_class
      @helpers_class ||= Class.new(Hotcell::Manipulator)
    end
  end
end
