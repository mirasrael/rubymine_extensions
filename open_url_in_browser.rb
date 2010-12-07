include Java

require "code_insight/code_insight_helper"
require "editor_action_helper.rb"

import org.jetbrains.plugins.ruby.ruby.lang.TextUtil unless defined? TextUtil
import org.jetbrains.plugins.ruby.utils.NamingConventions unless defined? NamingConventions
import com.intellij.refactoring.util.CommonRefactoringUtil unless defined? CommonRefactoringUtil

def get_dijit_name(file)
  file_path = file.get_virtual_file.get_path
  case file_path
    when /\/public\/(.*\/tests\/.*\/.*)\.(html|js)/
      url = "#$1.html"
    when /\/public\/(ria\/src\/[^\/]+)(\/.*)\.js/
      url = "#$1/tests/#$2.html"
    else
      return nil
  end
  url.sub(/\.html$/, '').sub(/ria\/src\//, '').sub(/\/tests/, '').split(/\//).join('.')
end

register_editor_action "frontend_test_open_url_in_browser",
  :text                    => "Frontend Test: Open URL in browser",
  :description             => "Open URL in browser",
  :enable_in_modal_context => true do |editor, file|
  dijit_name = get_dijit_name(file)
  system("firefox 'http://localhost:3000/frontend_test/#{dijit_name}.html'") if dijit_name
end

register_editor_action "frontend_test_open_prebuilt_html_in_browser",
  :text                    => "Frontend Test: Open prebuilt html in browser",
  :description             => "Open prebuilt html in browser",
  :enable_in_modal_context => true do |editor, file|
  dijit_name = get_dijit_name(file)
  system("firefox 'http://localhost:3000/ria/prebuild/tests/#{dijit_name}.html'") if dijit_name
end

register_editor_action "dijit_go_to_test",
  :text                    => "Dijit: Go to test",
  :description             => "Go to test",
  :enable_in_modal_context => false do |editor, file|
  dijit_name = get_dijit_name(file)
  #editor
end