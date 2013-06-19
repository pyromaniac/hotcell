require 'puffer_markup/scope'

module PufferMarkup
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

    def hotcell_invoke method, *arguments
      scope[method]
    end
  end
end
