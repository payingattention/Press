class Array

  def peek
    return self[self.length-1] unless self.length < 1
    nil
  end

end