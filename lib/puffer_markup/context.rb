require 'puffer_markup/scope'

module PufferMarkup
  class Context
    attr_reader :scope, :rescuer, :reraise
    delegate :[], :[]=, :key?, :scoped, to: :scope

    DEFAULT_RESCUER = ->(e){ "#{e.class}: #{e.message}" }

    def initialize options = {}
      scope = options[:scope].presence
      scope ||= begin
        variables = (options[:variables] || {}).stringify_keys
        environment = (options[:environment] || {}).symbolize_keys
        variables.merge! environment
      end
      @scope = Scope.new scope
      @rescuer = options[:rescuer] || DEFAULT_RESCUER
      @reraise = !!options[:reraise]
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
