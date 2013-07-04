module Hotcell
  class Source
    PACK_MODE = 'c*'

    attr_reader :source, :file

    def self.wrap source, *args
      source.is_a?(Hotcell::Source) ? source : Source.new(source, *args)
    end

    def initialize source, file = nil
      @source, @file = source, file
    end

    def encoding
      'UTF-8'
    end

    def data
      @data ||= source.unpack(PACK_MODE)
    end

    def info position
      parsed = data[0..position]
      line = parsed.count(10) + 1
      lastnl = (parsed.rindex(10) || -1) + 1
      column = parsed[lastnl..position].pack(PACK_MODE).force_encoding(encoding).size
      { line: line, column: column }
    end

    def inspect
      "Source: `#{source}`"
    end
  end
end
