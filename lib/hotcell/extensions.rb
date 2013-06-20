NilClass.class_eval do
  include Hotcell::Manipulator::Mixin
  attr_accessor :hotcell_position
end

TrueClass.class_eval do
  include Hotcell::Manipulator::Mixin
  attr_accessor :hotcell_position
end

FalseClass.class_eval do
  include Hotcell::Manipulator::Mixin
  attr_accessor :hotcell_position
end

Numeric.class_eval do
  include Hotcell::Manipulator::Mixin
  attr_accessor :hotcell_position
end

String.class_eval do
  include Hotcell::Manipulator::Mixin
  attr_accessor :hotcell_position
end

Regexp.class_eval do
  include Hotcell::Manipulator::Mixin
  attr_accessor :hotcell_position
end

Time.class_eval do
  include Hotcell::Manipulator::Mixin
end

Date.class_eval do
  include Hotcell::Manipulator::Mixin
end

Array.class_eval do
  include Hotcell::Manipulator::Mixin
end

Hash.class_eval do
  include Hotcell::Manipulator::Mixin

  def manipulator_invoke method, *arguments
    arguments.size == 0 && key?(method) ? self[method] : super
  end
end



