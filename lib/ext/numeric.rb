class Numeric

  def clamp(range)
    return self if range.include? self
    return self > range.max ? range.max : range.min
  end

end