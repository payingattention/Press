class String

  def line_trim!
    # remove prefixed line numbers
    self.gsub! /^\s\d\s{3}|^\d\d\s{3}|^\s{11,12}(\s|\d)\d\s{3}/, ''
    # strip white space
    self.strip_or_self!
    self
  end

  # if strip! doesn't have to modify anything, it returns nil.
  # I want it to return the unmodified string
  def strip_or_self!
    self.strip! || self
  end

  # We need a way to get nice titles out of strings
  def pretty_title!
    str = self
    str.downcase!
    str = str.split(" ").map { |word| word.capitalize! }.join(" ")
    str.gsub! /\sVs/, ' vs'
    str.gsub! /\sMd/, ' MD'
    str.gsub! /\sVersus/, ' versus'
    str.gsub! /\sLlc/, ' LLC'
    str.gsub! /\sPc/, ' PC'
    str.gsub! /\sPa/, ' PA'

    # I can't get this to work.. I want Mcfoo to be McFoo but for some reason this wont work -- it does work in rails console
    #str.gsub! /(\sMc)(.)/, "#{$1}#{$2.upcase}"
    str
  end


end