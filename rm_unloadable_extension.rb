class RmUnloadableExtension
  def load_extension
    @loaded = true
  end

  def unload_extension
    @loaded = false
  end

  def reload_extension
    unload_extension if @loaded
    load_extension
  end
end
