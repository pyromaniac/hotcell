NilClass.class_eval do
  include Hotcell::Tong::Mixin
end

TrueClass.class_eval do
  include Hotcell::Tong::Mixin
end

FalseClass.class_eval do
  include Hotcell::Tong::Mixin
end

Numeric.class_eval do
  include Hotcell::Tong::Mixin
end

String.class_eval do
  include Hotcell::Tong::Mixin

  manipulate :size, :length
end

Regexp.class_eval do
  include Hotcell::Tong::Mixin
end

Time.class_eval do
  include Hotcell::Tong::Mixin
end

Date.class_eval do
  include Hotcell::Tong::Mixin
end

Array.class_eval do
  include Hotcell::Tong::Mixin

  manipulate :first, :last, :count, :size, :length
end

Hash.class_eval do
  include Hotcell::Tong::Mixin

  manipulate :keys, :values, :count, :size, :length

  def tong_invoke method, *arguments
    if method == '[]'
      tong_invoke_brackets *arguments
    elsif tong_invokable? method
      send(method, *arguments)
    elsif arguments.count == 0
      self[method]
    end
  end
end



