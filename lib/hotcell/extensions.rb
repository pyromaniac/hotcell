NilClass.class_eval do
  include Hotcell::Manipulator::Mixin
end

TrueClass.class_eval do
  include Hotcell::Manipulator::Mixin
end

FalseClass.class_eval do
  include Hotcell::Manipulator::Mixin
end

Numeric.class_eval do
  include Hotcell::Manipulator::Mixin
end

String.class_eval do
  include Hotcell::Manipulator::Mixin

  manipulate :size, :length
end

Regexp.class_eval do
  include Hotcell::Manipulator::Mixin
end

Time.class_eval do
  include Hotcell::Manipulator::Mixin
end

Date.class_eval do
  include Hotcell::Manipulator::Mixin
end

Array.class_eval do
  include Hotcell::Manipulator::Mixin

  manipulate :first, :last, :count, :size, :length
end

Hash.class_eval do
  include Hotcell::Manipulator::Mixin

  manipulate :keys, :values, :count, :size, :length

  def manipulator_invoke method, *arguments
    if method == '[]'
      manipulator_invoke_brackets *arguments
    elsif manipulator_invokable? method
      send(method, *arguments)
    elsif arguments.count == 0
      self[method]
    end
  end
end



