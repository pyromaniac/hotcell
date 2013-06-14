module PufferMarkup
  class Scope
    def initialize scope = {}
      @scope = [scope]
    end

    def [] key
      cache[key]
    end

    def []= key, value
      clear_cache
      hash = scope.reverse_each.detect { |hash| hash.key? key }
      hash ||= scope.last
      hash[key] = value
    end

    def key? key
      cache.key?(key)
    end

    def push data
      cache.merge!(data)
      scope.push(data)
    end

    def pop
      clear_cache
      scope.pop if scope.size > 1
    end

    def scoped data
      push(data)
      yield
    ensure
      pop
    end

  private

    def scope
      @scope
    end

    def reduce
      scope.inject({}, &:merge)
    end

    def cache
      @cache ||= reduce
    end

    def clear_cache
      @cache = nil
    end
  end
end
