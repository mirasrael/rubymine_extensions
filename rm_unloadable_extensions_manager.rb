RUBYMINE_ROOT = "/home/bondarev/etc/RubyMine-96.1146"

include Java

require "#{RUBYMINE_ROOT}/rb/api/code_insight/code_insight_helper"
require "#{RUBYMINE_ROOT}/rb/api/editor_action_helper.rb"
require File.dirname(__FILE__) + "/rm_unloadable_extension.rb"
require "yaml"

import org.jetbrains.plugins.ruby.ruby.lang.TextUtil unless defined? TextUtil
import org.jetbrains.plugins.ruby.utils.NamingConventions unless defined? NamingConventions
import com.intellij.refactoring.util.CommonRefactoringUtil unless defined? CommonRefactoringUtil

class UnloadableExtensionsManager
  def initialize
    @extensions = {}
  end

  def register_extension(file_name, editor = nil)
    dir = Dir.new(File.join(File.dirname(__FILE__), "extensions"))
    name_without_extension = file_name.gsub(/\..*?$/, "")
    class_name = NamingConventions.to_camel_case(name_without_extension)

    @extensions[class_name].unload_extension unless @extensions[class_name].nil?

    load File.join(dir.path, file_name)
    extension = Kernel.const_get(class_name).new
    extension.load_extension
    @extensions[class_name] = extension
  end
           
  def load_extensions
    dir = Dir.new(File.join(File.dirname(__FILE__), "extensions"))
    dir.each do |f|
      register_extension f unless f == '.' || f == '..'
    end
  end
end

unloadable_extensions_manager = UnloadableExtensionsManager.new
unloadable_extensions_manager.load_extensions

register_editor_action "reload_unloadable_extension",
                       :text => "Reload Unloadable Extension",
                       :description => "Reload extension without IDE restart.",
                       :enable_in_modal_context => true,
                       :shortcut => "control shift G" do |editor, file|
  if file.get_name =~ /\.xrb/
    unloadable_extensions_manager.register_extension file.get_name, editor
  end
end