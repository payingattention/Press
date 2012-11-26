class Hash

  def remove_nils
    delete_if {|k,v| k == nil }
  end

end