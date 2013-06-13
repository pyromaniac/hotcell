module PufferMarkup
  class Summoner < PufferMarkup::Node
    def render context
      values = values(context)
      object = values.first | context
      object.send(values.second, *values.from(2))
    end
  end
end
