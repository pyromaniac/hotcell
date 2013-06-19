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
end

Hash.class_eval do
  include Hotcell::Manipulator::Mixin
end



