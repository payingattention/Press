class Array

  def peek
    return self[self.length-1] unless self.length < 1
    nil
  end

  # I'm shocked this isn't in the core language.
  def map_with_index &block
    index = 0
    map do |element|
      result = yield element, index
      index += 1
      result
    end
  end

end