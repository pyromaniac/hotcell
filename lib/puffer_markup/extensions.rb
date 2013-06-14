NilClass.class_eval do
  include PufferMarkup::Hotcell::Mixin
end

TrueClass.class_eval do
  include PufferMarkup::Hotcell::Mixin
end

FalseClass.class_eval do
  include PufferMarkup::Hotcell::Mixin
end

Numeric.class_eval do
  include PufferMarkup::Hotcell::Mixin
end

String.class_eval do
  include PufferMarkup::Hotcell::Mixin
end

Regexp.class_eval do
  include PufferMarkup::Hotcell::Mixin
end

Time.class_eval do
  include PufferMarkup::Hotcell::Mixin
end

Date.class_eval do
  include PufferMarkup::Hotcell::Mixin
end

Array.class_eval do
  include PufferMarkup::Hotcell::Mixin
end

Hash.class_eval do
  include PufferMarkup::Hotcell::Mixin
end



