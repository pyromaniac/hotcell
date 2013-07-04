module Hotcell
  # Base template resolving class for `include` command.
  # Please inherit your own resolvers from it.
  class Resolver
    def template path, context = nil
      cache(path, context) do
        source = resolve path, context
        Template.parse(source)
      end
    end

    # Returns template source
    # Not implemented by default
    def resolve path, context = nil
      raise NotImplementedError, 'Default resolver`s template resolve function is not implemented'
    end

    # Caches parsed template
    # No cache by default
    def cache path, context = nil, &block
      @cache ||= {}
      @cache[path] ||= block.call
    end
  end

  # Basic file system resolver class.
  # Ex:
  #   resolver = Hotcell::FileSystemResolver.new('/Users/username/work/project/app/views')
  #   resolver.template('articles/new') #=> returns Hotcell::Template instance
  #                                     # for `/Users/username/work/project/app/views/articles/new.hc`
  class FileSystemResolver < Resolver
    attr_reader :root

    def initialize root
      @root = root.to_s
    end

    def resolve path, context = nil
      full_path = File.expand_path path, root
      full_path = "#{full_path}.hc"
      File.read(full_path)
    end
  end
end
