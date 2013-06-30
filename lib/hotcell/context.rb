require 'hotcell/scope'

module Hotcell
  class Context
    attr_reader :options
    delegate :[], :[]=, :key?, :scoped, to: :scope

    DEFAULT_RESCUER = ->(e){ "#{e.class}: #{e.message}" }

    def initialize options = {}
      @options = normalize_options options
    end

    def normalize_options options
      options = options.dup

      scope = options.delete(:scope) || {}
      scope.merge! (options.delete(:variables) || {}).stringify_keys
      scope.merge! (options.delete(:environment) || {}).symbolize_keys

      shared = options.delete(:shared).presence || {}
      helpers = Array.wrap(options.delete(:helpers))

      rescuer = options.delete(:rescuer) || DEFAULT_RESCUER
      reraise = !!options.delete(:reraise)

      scope.merge!(options.stringify_keys)

      { scope: scope, shared: shared, helpers: helpers, reraise: reraise, rescuer: rescuer }
    end

    def scope
      @scope ||= Scope.new options[:scope]
    end

    def shared
      @shared ||= options[:shared]
    end

    def safe *default
      yield
    rescue => e
      rescue_result = options[:rescuer].call(e)
      default.size > 0 ? default.first : rescue_result
    ensure
      raise e if e && options[:reraise]
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
      @helpers_class ||= Class.new(Hotcell::Manipulator).tap do |klass|
        options[:helpers].each { |helper| klass.send(:include, helper) }
      end
    end
  end
end
